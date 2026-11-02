class_name AcaiMinigame
extends MiniGameBase
## Cardápio oficial da Açaiteria para o Primeiro Encontro de Miguel e Maria Fernanda.
## Exibe todo o cardápio (Tamanho, Base e Complementos) de forma visual, intuitiva e acessível por mouse e teclado.

var selected_size_idx: int = 1  # 500ml padrão
var selected_base_idx: int = 0  # Tradicional padrão
var selected_toppings: Array[String] = ["Leite em Pó", "Granola Crocante"]

var _ui_root: Control
var _done: bool = false
var _result_data: Dictionary = {}
var _all_buttons: Array[Button] = []
var _focus_idx: int = 0

var sizes: Array = ["300ml (Pequeno)", "500ml (Médio)", "700ml (Grande)"]
var bases: Array = ["Tradicional", "Com Banana", "Com Morango"]
var complements: Array = [
	"Leite em Pó",
	"Granola Crocante",
	"Morangos Frescos",
	"Banana Fatiada",
	"Leite Condensado",
	"Paçoca de Amendoim",
	"Gotas de Chocolate"
]

var _size_buttons: Array[Button] = []
var _base_buttons: Array[Button] = []
var _comp_buttons: Array[Button] = []
var _confirm_btn: Button
var _status_lbl: Label


func _ready() -> void:
	load_config("res://data/minigames/acai.json")
	if config.has("sizes"):
		sizes = config["sizes"]
	if config.has("bases"):
		bases = config["bases"]
	if config.has("complements"):
		complements = config["complements"]


func _intro() -> Dictionary:
	return {
		"title": "AÇAITERIA DO BAIRRO",
		"lines": [
			"Chegou a hora de escolher o açaí do encontro!",
			"Clique com o mouse nas opções ou use as setas do teclado.",
			"Escolha o tamanho, a base e até 4 acompanhamentos."
		],
		"hint": "[Espaço / Enter] Abrir Cardápio",
	}


func _results(result: Dictionary) -> Dictionary:
	var top_str: String = "Nenhum"
	var tops: Array = result.get("toppings", [])
	if not tops.is_empty():
		top_str = ", ".join(tops)

	return {
		"title": "PEDIDO CONFIRMADO!",
		"lines": [
			"Tamanho: %s" % result.get("size", "500ml"),
			"Base: %s" % result.get("base", "Tradicional"),
			"Acompanhamentos: %s" % top_str,
			"",
			"\"Caprichado do jeito que a gente gosta!\""
		],
		"hint": "[Espaço / Enter] Ir para a mesa",
	}


func _play() -> Dictionary:
	_build_cardapio_ui()

	while not _done:
		_handle_keyboard_nav()
		await get_tree().process_frame

	if _ui_root != null:
		_ui_root.queue_free()

	return _result_data


func _build_cardapio_ui() -> void:
	_ui_root = Control.new()
	_ui_root.custom_minimum_size = Vector2(320, 180)
	_ui_root.size = Vector2(320, 180)
	layer.add_child(_ui_root)

	# Fundo escurecido aconchegante
	var bg := ColorRect.new()
	bg.color = Color(0.06, 0.04, 0.09, 0.92)
	bg.size = Vector2(320, 180)
	_ui_root.add_child(bg)

	# Painel do Cardápio estilo lousa de açaiteria
	var panel := Panel.new()
	panel.size = Vector2(304, 168)
	panel.position = Vector2(8, 6)
	var st := StyleBoxFlat.new()
	st.bg_color = Color(0.12, 0.08, 0.18)
	st.border_color = Color(0.85, 0.70, 0.30) # borda dourada
	st.set_border_width_all(2)
	st.set_corner_radius_all(4)
	panel.add_theme_stylebox_override("panel", st)
	_ui_root.add_child(panel)

	# Título do Cardápio
	var header := Label.new()
	header.text = "CARDÁPIO DA AÇAITERIA"
	header.position = Vector2(0, 4)
	header.size = Vector2(304, 16)
	header.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	header.add_theme_font_size_override("font_size", 16)
	header.add_theme_color_override("font_color", Color(1.0, 0.90, 0.40))
	panel.add_child(header)

	_all_buttons.clear()
	_size_buttons.clear()
	_base_buttons.clear()
	_comp_buttons.clear()

	# 1. Seção Tamanho
	var lbl_size := Label.new()
	lbl_size.text = "1. TAMANHO DA TIGELA:"
	lbl_size.position = Vector2(10, 22)
	lbl_size.size = Vector2(284, 13)
	lbl_size.add_theme_font_size_override("font_size", 12)
	lbl_size.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
	panel.add_child(lbl_size)

	for i in range(sizes.size()):
		var btn := Button.new()
		btn.text = sizes[i]
		btn.position = Vector2(10 + i * 95, 36)
		btn.size = Vector2(92, 16)
		btn.add_theme_font_size_override("font_size", 12)
		btn.focus_mode = Control.FOCUS_NONE
		panel.add_child(btn)
		_size_buttons.append(btn)
		_all_buttons.append(btn)
		var idx := i
		btn.pressed.connect(func():
			selected_size_idx = idx
			_update_button_visuals()
		)

	# 2. Seção Base
	var lbl_base := Label.new()
	lbl_base.text = "2. SABOR DA BASE:"
	lbl_base.position = Vector2(10, 54)
	lbl_base.size = Vector2(284, 13)
	lbl_base.add_theme_font_size_override("font_size", 12)
	lbl_base.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
	panel.add_child(lbl_base)

	for i in range(bases.size()):
		var btn := Button.new()
		btn.text = bases[i]
		btn.position = Vector2(10 + i * 95, 68)
		btn.size = Vector2(92, 16)
		btn.add_theme_font_size_override("font_size", 12)
		btn.focus_mode = Control.FOCUS_NONE
		panel.add_child(btn)
		_base_buttons.append(btn)
		_all_buttons.append(btn)
		var idx := i
		btn.pressed.connect(func():
			selected_base_idx = idx
			_update_button_visuals()
		)

	# 3. Seção Complementos (2 colunas)
	var lbl_comp := Label.new()
	lbl_comp.name = "CompLabel"
	lbl_comp.text = "3. COMPLEMENTOS (Até 4):"
	lbl_comp.position = Vector2(10, 86)
	lbl_comp.size = Vector2(200, 13)
	lbl_comp.add_theme_font_size_override("font_size", 12)
	lbl_comp.add_theme_color_override("font_color", Color(0.7, 0.9, 1.0))
	panel.add_child(lbl_comp)

	_status_lbl = Label.new()
	_status_lbl.position = Vector2(180, 86)
	_status_lbl.size = Vector2(114, 13)
	_status_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	_status_lbl.add_theme_font_size_override("font_size", 11)
	_status_lbl.add_theme_color_override("font_color", Color(1.0, 0.85, 0.3))
	panel.add_child(_status_lbl)

	for i in range(complements.size()):
		var col := i % 2
		var row := i / 2
		var btn := Button.new()
		btn.text = complements[i]
		btn.position = Vector2(10 + col * 144, 100 + row * 13)
		btn.size = Vector2(140, 13)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.add_theme_font_size_override("font_size", 11)
		btn.focus_mode = Control.FOCUS_NONE
		panel.add_child(btn)
		_comp_buttons.append(btn)
		_all_buttons.append(btn)
		var c_name: String = complements[i]
		btn.pressed.connect(func():
			if selected_toppings.has(c_name):
				selected_toppings.erase(c_name)
			else:
				if selected_toppings.size() < 4:
					selected_toppings.append(c_name)
			_update_button_visuals()
		)

	# 4. Botão de Confirmar Pedido
	_confirm_btn = Button.new()
	_confirm_btn.text = ">>> CONFIRMAR PEDIDO <<<"
	_confirm_btn.position = Vector2(72, 148)
	_confirm_btn.size = Vector2(160, 16)
	_confirm_btn.add_theme_font_size_override("font_size", 13)
	_confirm_btn.focus_mode = Control.FOCUS_NONE
	panel.add_child(_confirm_btn)
	_all_buttons.append(_confirm_btn)

	_confirm_btn.pressed.connect(func():
		_finish_order()
	)

	_update_button_visuals()


func _update_button_visuals() -> void:
	# Atualiza botões de tamanho
	for i in range(_size_buttons.size()):
		var btn := _size_buttons[i]
		var is_sel := (i == selected_size_idx)
		_style_pill(btn, is_sel, Color(0.2, 0.5, 0.3) if is_sel else Color(0.2, 0.15, 0.25))

	# Atualiza botões de base
	for i in range(_base_buttons.size()):
		var btn := _base_buttons[i]
		var is_sel := (i == selected_base_idx)
		_style_pill(btn, is_sel, Color(0.4, 0.2, 0.6) if is_sel else Color(0.2, 0.15, 0.25))

	# Atualiza botões de complementos
	for i in range(_comp_buttons.size()):
		var btn := _comp_buttons[i]
		var c_name: String = complements[i]
		var is_sel := selected_toppings.has(c_name)
		btn.text = "[%s] %s" % ["✓" if is_sel else " ", c_name]
		if is_sel:
			btn.add_theme_color_override("font_color", Color(1.0, 0.95, 0.4))
		else:
			btn.add_theme_color_override("font_color", Color(0.85, 0.85, 0.85))

	# Atualiza status
	if _status_lbl != null:
		_status_lbl.text = "%d de 4 escolhidos" % selected_toppings.size()

	# Atualiza botão confirmar
	var c_style := StyleBoxFlat.new()
	c_style.bg_color = Color(0.12, 0.60, 0.25)
	c_style.border_color = Color(0.9, 0.8, 0.3)
	c_style.set_border_width_all(1)
	c_style.set_corner_radius_all(3)
	_confirm_btn.add_theme_stylebox_override("normal", c_style)
	_confirm_btn.add_theme_color_override("font_color", Color.WHITE)

	_highlight_current_focus()


func _style_pill(btn: Button, is_selected: bool, active_color: Color) -> void:
	var st := StyleBoxFlat.new()
	st.bg_color = active_color
	st.border_color = Color(1.0, 0.85, 0.3) if is_selected else Color(0.35, 0.3, 0.4)
	st.set_border_width_all(2 if is_selected else 1)
	st.set_corner_radius_all(3)
	btn.add_theme_stylebox_override("normal", st)
	btn.add_theme_color_override("font_color", Color.WHITE if is_selected else Color(0.7, 0.7, 0.7))


func _highlight_current_focus() -> void:
	for i in range(_all_buttons.size()):
		var btn := _all_buttons[i]
		if i == _focus_idx:
			btn.modulate = Color(1.3, 1.3, 1.0)
		else:
			btn.modulate = Color(1.0, 1.0, 1.0)


func _handle_keyboard_nav() -> void:
	if _done or _all_buttons.is_empty():
		return

	if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("move_down"):
		_focus_idx = (_focus_idx + 1) % _all_buttons.size()
		_highlight_current_focus()
	elif Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("move_up"):
		_focus_idx = (_focus_idx - 1 + _all_buttons.size()) % _all_buttons.size()
		_highlight_current_focus()
	elif Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("ui_accept"):
		if _focus_idx >= 0 and _focus_idx < _all_buttons.size():
			_all_buttons[_focus_idx].emit_signal("pressed")


func _finish_order() -> void:
	_result_data = {
		"size": sizes[selected_size_idx],
		"base": bases[selected_base_idx],
		"toppings": selected_toppings.duplicate()
	}
	_done = true

extends CanvasLayer
## Controles de Toque Virtuais para Dispositivos Móveis (Celulares e Tablets).
## Detecta telas sensíveis ao toque automaticamente e fornece D-Pad e botões de ação (A/B),
## além de botão para alternar a visibilidade a qualquer momento.

var _enabled: bool = false
var _pad_container: Control
var _toggle_btn: Button

# Estado dos botões do direcional
var _touch_pos := Vector2.ZERO
var _is_dragging_dpad := false
var _active_actions: Dictionary = {
	"up": false,
	"down": false,
	"left": false,
	"right": false,
	"a": false,
	"b": false
}


func _ready() -> void:
	layer = 80

	# Ativa por padrão em dispositivos móveis, web mobile ou telas de toque
	var is_mobile := (
		DisplayServer.is_touchscreen_available() or
		OS.has_feature("mobile") or
		OS.has_feature("web_android") or
		OS.has_feature("web_ios")
	)
	_enabled = is_mobile

	_build_ui()


func _build_ui() -> void:
	# Container raiz que respeita a escala da tela
	var root := Control.new()
	root.set_anchors_preset(Control.PRESET_FULL_RECT)
	root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(root)

	# 1. Botão discreto para ligar/desligar os controles na tela
	_toggle_btn = Button.new()
	_toggle_btn.text = "🎮"
	_toggle_btn.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	_toggle_btn.position = Vector2(-28, 4)
	_toggle_btn.size = Vector2(24, 20)
	_toggle_btn.modulate = Color(1.0, 1.0, 1.0, 0.45)
	_toggle_btn.focus_mode = Control.FOCUS_NONE
	_toggle_btn.pressed.connect(_on_toggle_pressed)
	root.add_child(_toggle_btn)

	# 2. Container dos Controles Virtuais
	_pad_container = Control.new()
	_pad_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	_pad_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_pad_container.visible = _enabled
	root.add_child(_pad_container)

	# D-Pad (Lado Esquerdo Inferior)
	var dpad_box := Control.new()
	dpad_box.set_anchors_preset(Control.PRESET_BOTTOM_LEFT)
	dpad_box.position = Vector2(10, -75)
	dpad_box.size = Vector2(70, 70)
	_pad_container.add_child(dpad_box)

	# Fundo sutil do D-Pad
	var dpad_bg := Panel.new()
	dpad_bg.size = Vector2(66, 66)
	dpad_bg.position = Vector2(2, 2)
	var bg_style := StyleBoxFlat.new()
	bg_style.bg_color = Color(0.12, 0.12, 0.15, 0.35)
	bg_style.set_corner_radius_all(33)
	dpad_bg.add_theme_stylebox_override("panel", bg_style)
	dpad_box.add_child(dpad_bg)

	# Botões direcionais individuais
	_create_dir_btn(dpad_box, "▲", Vector2(23, 2), "up")
	_create_dir_btn(dpad_box, "▼", Vector2(23, 44), "down")
	_create_dir_btn(dpad_box, "◄", Vector2(2, 23), "left")
	_create_dir_btn(dpad_box, "►", Vector2(44, 23), "right")

	# Botões de Ação (Lado Direito Inferior)
	var action_box := Control.new()
	action_box.set_anchors_preset(Control.PRESET_BOTTOM_RIGHT)
	action_box.position = Vector2(-75, -70)
	action_box.size = Vector2(70, 70)
	_pad_container.add_child(action_box)

	# Botão B (Correr / Acelerar bicicleta)
	var btn_b := Button.new()
	btn_b.text = "B"
	btn_b.position = Vector2(2, 12)
	btn_b.size = Vector2(26, 26)
	btn_b.focus_mode = Control.FOCUS_NONE
	var style_b := StyleBoxFlat.new()
	style_b.bg_color = Color(0.18, 0.45, 0.75, 0.60)
	style_b.set_corner_radius_all(13)
	btn_b.add_theme_stylebox_override("normal", style_b)
	btn_b.button_down.connect(func(): _press_action("b"))
	btn_b.button_up.connect(func(): _release_action("b"))
	action_box.add_child(btn_b)

	# Botão A (Confirmar / Interagir / Chutar / Avançar)
	var btn_a := Button.new()
	btn_a.text = "A"
	btn_a.position = Vector2(34, 30)
	btn_a.size = Vector2(32, 32)
	btn_a.focus_mode = Control.FOCUS_NONE
	var style_a := StyleBoxFlat.new()
	style_a.bg_color = Color(0.25, 0.72, 0.38, 0.65)
	style_a.set_corner_radius_all(16)
	btn_a.add_theme_stylebox_override("normal", style_a)
	btn_a.button_down.connect(func(): _press_action("a"))
	btn_a.button_up.connect(func(): _release_action("a"))
	action_box.add_child(btn_a)


func _create_dir_btn(parent: Control, symbol: String, pos: Vector2, dir_key: String) -> Button:
	var b := Button.new()
	b.text = symbol
	b.position = pos
	b.size = Vector2(20, 20)
	b.focus_mode = Control.FOCUS_NONE
	var s := StyleBoxFlat.new()
	s.bg_color = Color(0.2, 0.2, 0.25, 0.55)
	s.set_corner_radius_all(5)
	b.add_theme_stylebox_override("normal", s)
	b.button_down.connect(func(): _press_action(dir_key))
	b.button_up.connect(func(): _release_action(dir_key))
	parent.add_child(b)
	return b


func _on_toggle_pressed() -> void:
	_enabled = not _enabled
	_pad_container.visible = _enabled and not GameState.controls_locked


func _process(_delta: float) -> void:
	# Oculta automaticamente durante cutscenes e diálogos para não poluir a tela
	var should_show := _enabled and not GameState.controls_locked
	if _pad_container.visible != should_show:
		_pad_container.visible = should_show
		if not should_show:
			_release_all()


func _press_action(action: String) -> void:
	if _active_actions.get(action, false):
		return
	_active_actions[action] = true

	match action:
		"up":
			_emit_event("move_up", true)
			_emit_event("ui_up", true)
		"down":
			_emit_event("move_down", true)
			_emit_event("ui_down", true)
		"left":
			_emit_event("move_left", true)
			_emit_event("ui_left", true)
			_emit_event("aim_left", true)
		"right":
			_emit_event("move_right", true)
			_emit_event("ui_right", true)
			_emit_event("aim_right", true)
		"a":
			_emit_event("interact", true)
			_emit_event("confirm", true)
			_emit_event("shoot", true)
			_emit_event("ui_accept", true)
		"b":
			_emit_event("run", true)


func _release_action(action: String) -> void:
	if not _active_actions.get(action, false):
		return
	_active_actions[action] = false

	match action:
		"up":
			_emit_event("move_up", false)
			_emit_event("ui_up", false)
		"down":
			_emit_event("move_down", false)
			_emit_event("ui_down", false)
		"left":
			_emit_event("move_left", false)
			_emit_event("ui_left", false)
			_emit_event("aim_left", false)
		"right":
			_emit_event("move_right", false)
			_emit_event("ui_right", false)
			_emit_event("aim_right", false)
		"a":
			_emit_event("interact", false)
			_emit_event("confirm", false)
			_emit_event("shoot", false)
			_emit_event("ui_accept", false)
		"b":
			_emit_event("run", false)


func _release_all() -> void:
	for action in _active_actions.keys():
		if _active_actions[action]:
			_release_action(action)


func _emit_event(action_name: String, pressed: bool) -> void:
	var ev := InputEventAction.new()
	ev.action = action_name
	ev.pressed = pressed
	Input.parse_input_event(ev)

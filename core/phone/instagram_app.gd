class_name InstagramApp
extends Control
## Aplicativo simulado do Instagram em pixel art.
## Suporta o envio da solicitação por Maria Fernanda (Cena 2)
## e a aceitação da solicitação por Miguel (Cena 3).

signal action_completed

enum Mode { MARIA_FOLLOW_MIGUEL, MIGUEL_ACCEPT_MARIA }
var mode: Mode = Mode.MARIA_FOLLOW_MIGUEL

var action_button: Button
var is_done: bool = false


const SCREEN_WIDTH: float = 128.0
const SCREEN_HEIGHT: float = 158.0


func setup(p_mode: Mode) -> void:
	mode = p_mode
	custom_minimum_size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	_build_ui()


func _build_ui() -> void:
	# Fundo branco do Instagram
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color("ffffff")
	add_child(bg)

	# Barra de cabeçalho
	var header := Panel.new()
	header.size = Vector2(SCREEN_WIDTH, 20)
	var header_style := StyleBoxFlat.new()
	header_style.bg_color = Color("fafafa")
	header_style.border_color = Color("e0e0e0")
	header_style.border_width_bottom = 1
	header.add_theme_stylebox_override("panel", header_style)
	add_child(header)

	var title_lbl := Label.new()
	title_lbl.size = Vector2(SCREEN_WIDTH, 20)
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 14)
	title_lbl.add_theme_color_override("font_color", Color("262626"))
	header.add_child(title_lbl)

	if mode == Mode.MARIA_FOLLOW_MIGUEL:
		title_lbl.text = "@miguel"
		_build_profile_view()
	else:
		title_lbl.text = "Notificações"
		_build_requests_view()


func _build_profile_view() -> void:
	# Foto de perfil de Miguel
	var avatar := TextureRect.new()
	var tex := load("res://assets/sprites/ui/avatar_miguel.png")
	if tex != null:
		avatar.texture = tex
	avatar.position = Vector2(10, 26)
	avatar.size = Vector2(24, 24)
	add_child(avatar)

	# Estatísticas do perfil
	var stats := Label.new()
	stats.text = "12     280     195\nposts   seguidores   seguindo"
	stats.position = Vector2(40, 26)
	stats.add_theme_font_size_override("font_size", 11)
	stats.add_theme_color_override("font_color", Color("505050"))
	add_child(stats)

	# Bio
	var bio := Label.new()
	bio.text = "Miguel\nBasquete • RJ"
	bio.position = Vector2(10, 54)
	bio.add_theme_font_size_override("font_size", 13)
	bio.add_theme_color_override("font_color", Color("262626"))
	add_child(bio)

	# Botão Seguir
	action_button = Button.new()
	action_button.text = "Seguir"
	action_button.position = Vector2(10, 78)
	action_button.size = Vector2(108, 18)
	action_button.focus_mode = Control.FOCUS_ALL
	_style_button(action_button, Color("0095f6"), Color.WHITE)
	action_button.pressed.connect(_on_maria_follow_pressed)
	add_child(action_button)
	action_button.grab_focus()

	# Grid de fotos simulado
	var grid_y := 102
	for i in 6:
		var col := i % 3
		var row := i / 3
		var photo := ColorRect.new()
		photo.position = Vector2(10 + col * 37, grid_y + row * 26)
		photo.size = Vector2(34, 23)
		photo.color = Color("dcdcdc") if (col + row) % 2 == 0 else Color("cfd8dc")
		add_child(photo)


func _build_requests_view() -> void:
	# Item de notificação / solicitação
	var item_bg := Panel.new()
	item_bg.position = Vector2(6, 26)
	item_bg.size = Vector2(116, 44)
	var st := StyleBoxFlat.new()
	st.bg_color = Color("f5f7fa")
	st.set_corner_radius_all(4)
	item_bg.add_theme_stylebox_override("panel", st)
	add_child(item_bg)

	var avatar := TextureRect.new()
	var tex := load("res://assets/sprites/ui/avatar_maria.png")
	if tex != null:
		avatar.texture = tex
	avatar.position = Vector2(4, 8)
	avatar.size = Vector2(22, 22)
	item_bg.add_child(avatar)

	var info := Label.new()
	info.text = "maria_fernanda\nsolicitou seguir você."
	info.position = Vector2(30, 4)
	info.add_theme_font_size_override("font_size", 12)
	info.add_theme_color_override("font_color", Color("262626"))
	item_bg.add_child(info)

	action_button = Button.new()
	action_button.text = "Confirmar"
	action_button.position = Vector2(30, 24)
	action_button.size = Vector2(70, 16)
	action_button.focus_mode = Control.FOCUS_ALL
	_style_button(action_button, Color("0095f6"), Color.WHITE)
	action_button.pressed.connect(_on_miguel_accept_pressed)
	item_bg.add_child(action_button)
	action_button.grab_focus()


func _style_button(btn: Button, bg_col: Color, text_col: Color) -> void:
	btn.add_theme_font_size_override("font_size", 12)
	btn.add_theme_color_override("font_color", text_col)
	var st := StyleBoxFlat.new()
	st.bg_color = bg_col
	st.set_corner_radius_all(3)
	btn.add_theme_stylebox_override("normal", st)
	btn.add_theme_stylebox_override("hover", st)
	btn.add_theme_stylebox_override("pressed", st)
	btn.add_theme_stylebox_override("focus", st)


func _on_maria_follow_pressed() -> void:
	if is_done:
		return
	is_done = true
	AudioManager.play_sfx("phone_click", -3.0)
	action_button.text = "Solicitado ✓"
	_style_button(action_button, Color("efefef"), Color("707070"))
	await get_tree().create_timer(1.2).timeout
	action_completed.emit()


func _on_miguel_accept_pressed() -> void:
	if is_done:
		return
	is_done = true
	AudioManager.play_sfx("phone_click", -3.0)
	action_button.text = "Seguindo ✓"
	_style_button(action_button, Color("efefef"), Color("707070"))
	await get_tree().create_timer(1.2).timeout
	action_completed.emit()


func _unhandled_input(event: InputEvent) -> void:
	if not visible or is_done:
		return
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact") or (event is InputEventKey and event.pressed and (event.keycode == KEY_SPACE or event.keycode == KEY_ENTER or event.keycode == KEY_KP_ENTER or event.keycode == KEY_E)):
		if action_button != null and is_instance_valid(action_button):
			action_button.emit_signal("pressed")
			action_button.emit_signal("pressed")

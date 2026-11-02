class_name WhatsAppApp
extends Control
## Aplicativo simulado do WhatsApp em pixel art (128x158).
## Exibe balões de mensagens, indicador de digitação e opções de resposta interativas.

signal conversation_ended

const SCREEN_WIDTH: float = 128.0
const SCREEN_HEIGHT: float = 158.0

var header: Panel
var status_label: Label
var chat_scroll: ScrollContainer
var messages_container: VBoxContainer
var choices_container: VBoxContainer


func _ready() -> void:
	custom_minimum_size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	size = Vector2(SCREEN_WIDTH, SCREEN_HEIGHT)
	_build_ui()


func _build_ui() -> void:
	# Fundo padrão de conversa do WhatsApp com bom contraste
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color("e5ddd5")
	add_child(bg)

	# Barra superior verde
	header = Panel.new()
	header.size = Vector2(SCREEN_WIDTH, 22)
	header.position = Vector2.ZERO
	var h_style := StyleBoxFlat.new()
	h_style.bg_color = Color("075e54") # verde escuro whatsapp
	header.add_theme_stylebox_override("panel", h_style)
	add_child(header)

	var avatar := TextureRect.new()
	var tex := load("res://assets/sprites/ui/avatar_maria.png")
	if tex != null:
		avatar.texture = tex
	avatar.position = Vector2(6, 3)
	avatar.size = Vector2(16, 16)
	header.add_child(avatar)

	var name_lbl := Label.new()
	name_lbl.text = "Maria Fernanda"
	name_lbl.position = Vector2(26, 1)
	name_lbl.add_theme_font_size_override("font_size", 14)
	name_lbl.add_theme_color_override("font_color", Color.WHITE)
	header.add_child(name_lbl)

	status_label = Label.new()
	status_label.text = "online"
	status_label.position = Vector2(26, 11)
	status_label.add_theme_font_size_override("font_size", 11)
	status_label.add_theme_color_override("font_color", Color("a8dfc8"))
	header.add_child(status_label)

	# Área de mensagens com scroll
	chat_scroll = ScrollContainer.new()
	chat_scroll.position = Vector2(3, 24)
	chat_scroll.size = Vector2(SCREEN_WIDTH - 6.0, SCREEN_HEIGHT - 28.0)
	chat_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(chat_scroll)

	messages_container = VBoxContainer.new()
	messages_container.custom_minimum_size = Vector2(SCREEN_WIDTH - 6.0, 0)
	messages_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	messages_container.add_theme_constant_override("separation", 5)
	chat_scroll.add_child(messages_container)

	# Área de opções de escolha do jogador
	choices_container = VBoxContainer.new()
	choices_container.position = Vector2(3, SCREEN_HEIGHT - 52.0)
	choices_container.size = Vector2(SCREEN_WIDTH - 6.0, 48.0)
	choices_container.add_theme_constant_override("separation", 2)
	choices_container.visible = false
	add_child(choices_container)


func set_typing(is_typing: bool) -> void:
	if status_label != null:
		status_label.text = "digitando..." if is_typing else "online"


func add_message(text: String, is_incoming: bool, time_str: String = "17:42") -> void:
	if is_incoming:
		AudioManager.play_sfx("phone_notification", -4.0)

	var bubble := PanelContainer.new()
	var style := StyleBoxFlat.new()
	if is_incoming:
		style.bg_color = Color("ffffff")
		style.border_color = Color("c8d0d5")
	else:
		style.bg_color = Color("d9fdd3") # verde clássico do whatsapp
		style.border_color = Color("a4e39c")
	style.set_border_width_all(1)
	style.set_corner_radius_all(4)
	style.content_margin_left = 5
	style.content_margin_right = 5
	style.content_margin_top = 3
	style.content_margin_bottom = 3
	bubble.add_theme_stylebox_override("panel", style)
	bubble.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN if is_incoming else Control.SIZE_SHRINK_END

	var content_box := VBoxContainer.new()
	content_box.add_theme_constant_override("separation", 1)

	var msg_label := Label.new()
	msg_label.text = text
	msg_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	msg_label.custom_minimum_size = Vector2(minf(94.0, text.length() * 6.5 + 8.0), 0)
	msg_label.add_theme_font_size_override("font_size", 14)
	msg_label.add_theme_color_override("font_color", Color("111b21")) # texto nítido e escuro oficial
	content_box.add_child(msg_label)

	var time_label := Label.new()
	time_label.text = time_str
	time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	time_label.add_theme_font_size_override("font_size", 11)
	time_label.add_theme_color_override("font_color", Color("54656f"))
	content_box.add_child(time_label)

	bubble.add_child(content_box)
	messages_container.add_child(bubble)

	await get_tree().process_frame
	await get_tree().process_frame
	chat_scroll.scroll_vertical = int(chat_scroll.get_v_scroll_bar().max_value)


func prompt_choice(options: Array) -> String:
	for child in choices_container.get_children():
		child.queue_free()

	choices_container.visible = true
	chat_scroll.size.y = SCREEN_HEIGHT - 26.0 - 50.0

	var selected_text := ""
	var buttons: Array[Button] = []

	for i in options.size():
		var opt: String = options[i]
		var btn := Button.new()
		btn.text = "[%d] %s" % [i + 1, opt]
		btn.add_theme_font_size_override("font_size", 12)
		btn.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		btn.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		btn.focus_mode = Control.FOCUS_ALL
		var st := StyleBoxFlat.new()
		st.bg_color = Color("ffffff")
		st.border_color = Color("075e54")
		st.set_border_width_all(1)
		st.set_corner_radius_all(3)
		btn.add_theme_stylebox_override("normal", st)
		var st_h := st.duplicate()
		st_h.bg_color = Color("e0f2f1")
		btn.add_theme_stylebox_override("hover", st_h)
		btn.add_theme_stylebox_override("focus", st_h)
		btn.add_theme_color_override("font_color", Color("075e54"))
		btn.pressed.connect(func():
			selected_text = opt
		)
		choices_container.add_child(btn)
		buttons.append(btn)

	if not buttons.is_empty():
		buttons[0].grab_focus()

	# Permite escolher tanto por clique no botão quanto pelas teclas [1], [2]
	while selected_text == "":
		if Input.is_key_pressed(KEY_1) or Input.is_key_pressed(KEY_KP_1):
			if options.size() >= 1:
				selected_text = options[0]
				break
		elif Input.is_key_pressed(KEY_2) or Input.is_key_pressed(KEY_KP_2):
			if options.size() >= 2:
				selected_text = options[1]
				break
		await get_tree().process_frame

	AudioManager.play_sfx("phone_click", -3.0)
	choices_container.visible = false
	chat_scroll.size.y = SCREEN_HEIGHT - 28.0
	return selected_text

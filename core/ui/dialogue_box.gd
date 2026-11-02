class_name DialogueBox
extends CanvasLayer
## Caixa de diálogo no estilo Stardew Valley: moldura na parte de baixo, etiqueta com o nome,
## texto letra por letra, seta piscando. SEM som de fala.
## Uso: await box.show_lines([{"speaker": "Nome", "text": "..."}])

signal finished
signal _advance

const CHARS_PER_SECOND := 45.0

var _root: Control
var _panel: Panel
var _name_panel: Panel
var _name_label: Label
var _text: Label
var _arrow: Polygon2D
var _typing: bool = false
var _progress: float = 0.0
var _open_frame: int = -1


func _ready() -> void:
	layer = 15
	add_to_group("dialogue_box")
	_build()
	_root.visible = false


func _style(bg: Color, border: Color, radius: int, width: int) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(radius)
	return s


func _build() -> void:
	_root = Control.new()
	_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	_root.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_root)

	_panel = Panel.new()
	_panel.position = Vector2(8, 122)
	_panel.size = Vector2(304, 52)
	_panel.add_theme_stylebox_override("panel", _style(Color("fff1cf"), Color("8a5a2b"), 4, 2))
	_root.add_child(_panel)

	_text = Label.new()
	_text.position = Vector2(8, 6)
	_text.size = Vector2(288, 40)
	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.add_theme_font_size_override("font_size", 16)
	_text.add_theme_color_override("font_color", Color("4a2f1a"))
	_text.add_theme_constant_override("line_spacing", 1)
	_panel.add_child(_text)

	_arrow = Polygon2D.new()
	_arrow.polygon = PackedVector2Array([Vector2(0, 0), Vector2(7, 0), Vector2(3.5, 4)])
	_arrow.color = Color("8a5a2b")
	_arrow.position = Vector2(290, 44)
	_panel.add_child(_arrow)
	var blink := create_tween().set_loops()
	blink.tween_property(_arrow, "modulate:a", 0.15, 0.4)
	blink.tween_property(_arrow, "modulate:a", 1.0, 0.4)

	_name_panel = Panel.new()
	_name_panel.position = Vector2(14, 106)
	_name_panel.size = Vector2(80, 18)
	_name_panel.add_theme_stylebox_override("panel", _style(Color("ffd98a"), Color("8a5a2b"), 3, 2))
	_root.add_child(_name_panel)

	_name_label = Label.new()
	_name_label.size = Vector2(80, 18)
	_name_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_name_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_name_label.add_theme_font_size_override("font_size", 14)
	_name_label.add_theme_color_override("font_color", Color("4a2f1a"))
	_name_panel.add_child(_name_label)


func show_lines(lines: Array) -> void:
	if lines.is_empty():
		return
	var was_locked := GameState.controls_locked
	GameState.controls_locked = true
	_root.visible = true
	_open_frame = Engine.get_process_frames()
	for line in lines:
		var who: String = line.get("speaker", "")
		if who != "":
			_name_panel.visible = true
			_name_label.text = who
			var w := maxf(60.0, who.length() * 7.5 + 16.0)
			_name_panel.size.x = w
			_name_label.size.x = w
		else:
			_name_panel.visible = false

		_text.text = line.get("text", "")
		_text.visible_characters = 0
		_progress = 0.0
		_typing = true
		_arrow.visible = false
		await _advance
	_root.visible = false
	await get_tree().process_frame
	GameState.controls_locked = was_locked
	finished.emit()


func _process(delta: float) -> void:
	if not _typing:
		return
	_progress += delta * CHARS_PER_SECOND
	_text.visible_characters = int(_progress)
	if _progress >= _text.text.length():
		_finish_typing()


func _finish_typing() -> void:
	_typing = false
	_text.visible_characters = -1
	_arrow.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not _root.visible or Engine.get_process_frames() == _open_frame:
		return
	var is_click := false
	if event is InputEventMouseButton:
		var mb := event as InputEventMouseButton
		is_click = mb.pressed and mb.button_index == MOUSE_BUTTON_LEFT
	if event.is_action_pressed("interact") or event.is_action_pressed("confirm") or is_click:
		get_viewport().set_input_as_handled()
		if _typing:
			_finish_typing()
		else:
			_advance.emit()

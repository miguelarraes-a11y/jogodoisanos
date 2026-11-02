class_name Interactable
extends Area2D
## Qualquer coisa com que o jogador pode interagir. Mostra um indicador discreto ("!")
## quando o jogador está perto e, se tiver falas, abre a caixa de diálogo.

signal interacted(who: Node)

@export var dialogue_ids: PackedStringArray = PackedStringArray()
@export var indicator_offset: Vector2 = Vector2(-4, -36)

var _indicator: Panel


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	monitoring = false
	monitorable = true
	_build_indicator()


static func create(pos: Vector2, radius: float, ids: Array) -> Interactable:
	var a := Interactable.new()
	a.position = pos
	a.dialogue_ids = PackedStringArray(ids)
	var shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = radius
	shape.shape = circle
	a.add_child(shape)
	return a


func _build_indicator() -> void:
	_indicator = Panel.new()
	_indicator.size = Vector2(9, 11)
	_indicator.position = indicator_offset
	_indicator.z_index = 100
	_indicator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var style := StyleBoxFlat.new()
	style.bg_color = Color("fff1cf")
	style.border_color = Color("8a5a2b")
	style.set_border_width_all(1)
	style.set_corner_radius_all(2)
	_indicator.add_theme_stylebox_override("panel", style)
	var label := Label.new()
	label.text = "!"
	label.size = Vector2(9, 11)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color("4a2f1a"))
	_indicator.add_child(label)
	_indicator.visible = false
	add_child(_indicator)


func set_highlight(on: bool) -> void:
	if _indicator:
		_indicator.visible = on


func interact(who: Node) -> void:
	interacted.emit(who)
	if dialogue_ids.is_empty():
		return
	var box: DialogueBox = get_tree().get_first_node_in_group("dialogue_box")
	if box == null:
		box = DialogueBox.new()
		get_tree().root.add_child(box)
	await box.show_lines(Dialogues.get_lines(Array(dialogue_ids)))

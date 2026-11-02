class_name CandySpot
extends Node2D
## Ponto de distribuição de doces de São Cosme e Damião.
## Um morador fica na porta/entrada da casa com saquinhos de doces.
## Tanto a jogadora (Maria Fernanda) quanto as amigas (Ana Clara e Gabriele)
## podem pegar saquinhos aqui enquanto houver estoque.

signal candy_taken(by_who: Character, remaining: int)

@export var stock: int = 4
@export var morador_facing: String = "down"

var resident: Character
var interactable: Interactable
var icon: Sprite2D
var approach_pos: Vector2


func setup(pos: Vector2, initial_stock: int, facing: String = "down") -> void:
	position = pos
	stock = initial_stock
	morador_facing = facing
	approach_pos = pos + (Vector2(0, 16) if facing == "down" else Vector2(0, -16))

	# Morador
	resident = Character.new()
	resident.character_id = "morador"
	resident.position = Vector2.ZERO
	add_child(resident)
	resident.facing = morador_facing
	resident.sprite.play("idle_" + morador_facing)

	# Ícone flutuante do saquinho de doces indicando disponibilidade
	icon = Sprite2D.new()
	var bag_tex := load("res://assets/tiles/candy_bag.png")
	if bag_tex != null:
		icon.texture = bag_tex
	icon.position = Vector2(0, -28)
	icon.z_index = 60
	add_child(icon)
	_animate_icon()

	# Área de interação para a jogadora
	interactable = Interactable.create(Vector2(0, 4), 18.0, [])
	interactable.indicator_offset = Vector2(-4, -40)
	interactable.interacted.connect(_on_interacted)
	add_child(interactable)


func _animate_icon() -> void:
	if not is_instance_valid(icon):
		return
	var t := create_tween().set_loops()
	t.tween_property(icon, "position:y", -30.0, 0.6).set_trans(Tween.TRANS_SINE)
	t.tween_property(icon, "position:y", -27.0, 0.6).set_trans(Tween.TRANS_SINE)


func _on_interacted(who: Node) -> void:
	if who is Character:
		try_take_candy(who)


## Tenta retirar um saquinho de doces. Retorna true se conseguiu.
func try_take_candy(who: Character) -> bool:
	if stock <= 0:
		_spawn_float_text("Acabou!", Color("d0d0d0"))
		return false

	stock -= 1
	candy_taken.emit(who, stock)
	_spawn_float_text("+1 Saquinho!", Color("ffdd44"))

	if stock <= 0:
		if icon != null and is_instance_valid(icon):
			icon.visible = false
		if interactable != null and is_instance_valid(interactable):
			interactable.set_highlight(false)
			interactable.monitorable = false
	return true


func _spawn_float_text(text: String, col: Color) -> void:
	var l := Label.new()
	l.text = text
	l.position = Vector2(-22, -32)
	l.add_theme_font_size_override("font_size", 8)
	l.add_theme_color_override("font_color", col)
	l.add_theme_color_override("font_outline_color", Color(0, 0, 0, 0.8))
	l.add_theme_constant_override("outline_size", 3)
	l.z_index = 80
	add_child(l)

	var t := create_tween()
	t.tween_property(l, "position:y", -46.0, 0.8).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	t.parallel().tween_property(l, "modulate:a", 0.0, 0.8).set_delay(0.2)
	t.tween_callback(l.queue_free)


func has_candy() -> bool:
	return stock > 0

class_name Bedroom
extends Node2D
## Base dos quartos da Cena 01: parede, piso, ordenação por profundidade, luz e utilitários.

var world: Node2D
var light: CanvasModulate
var clock: Sprite2D
var sleeper: Sleeper


func _init_room(width: int, wall_texture: String) -> void:
	PropFactory.make_ground(self, wall_texture, Rect2(0, 0, width, 42), -30)
	PropFactory.make_ground(self, "baseboard", Rect2(0, 42, width, 6), -29)
	PropFactory.make_ground(self, "floor_ceramic", Rect2(0, 48, width, 132), -30)
	world = Node2D.new()
	world.y_sort_enabled = true
	add_child(world)
	light = CanvasModulate.new()
	add_child(light)


## Mesinha com despertador em cima. Guarda o despertador em `clock`.
func add_clock_table(pos: Vector2) -> void:
	var table := PropFactory.make_prop(world, "side_table", pos)
	clock = Sprite2D.new()
	clock.texture = PropFactory.tex("alarm_clock")
	clock.centered = false
	clock.offset = Vector2(-4, -8)
	clock.position = Vector2(0, -10)
	table.add_child(clock)


## Cama com alguém dormindo. overlay_y = altura do colchão onde a pessoa deita.
func add_sleeper_bed(bed_texture: String, pos: Vector2, character_id: String, overlay_y: float) -> void:
	var bed := PropFactory.make_prop(world, bed_texture, pos)
	sleeper = Sleeper.new()
	sleeper.setup(character_id)
	sleeper.position = Vector2(0, overlay_y)
	bed.add_child(sleeper)


func spawn_standing(character_id: String, pos: Vector2) -> Character:
	var c := Character.new()
	c.character_id = character_id
	c.position = pos
	world.add_child(c)
	return c

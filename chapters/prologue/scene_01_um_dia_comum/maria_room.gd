class_name MariaRoom
extends Bedroom
## Quarto da Maria Fernanda: 160x180, BELICHE (ela dorme na cama de CIMA) e o cachorro Kovak.

const WIDTH := 160
const BUNK_POS := Vector2(56, 100)
## Pé da escadinha, onde ela desce (lado direito da beliche).
const LADDER_EXIT := Vector2(82, 106)

var kovak: Sprite2D


func _ready() -> void:
	_init_room(WIDTH, "wall_maria")
	add_sleeper_bed("bunk_bed", BUNK_POS, "maria_fernanda", -26.0)
	add_clock_table(Vector2(20, 66))
	PropFactory.make_prop(world, "window_curtain", Vector2(92, 40))
	PropFactory.make_prop(world, "door_wood", Vector2(116, 48))
	PropFactory.make_prop(world, "wardrobe", Vector2(146, 60))
	# Kovak: vira-lata pequeno, preto e branco. Frame 0 = deitado, frame 1 = cabeça levantada.
	kovak = Sprite2D.new()
	kovak.texture = load("res://assets/sprites/characters/kovak.png")
	kovak.hframes = 2
	kovak.centered = false
	kovak.offset = Vector2(-11, -14)
	kovak.position = Vector2(100, 128)
	world.add_child(kovak)

class_name MiguelRoom
extends Bedroom
## Quarto do Miguel: 320x180, TRÊS camas. A cama dele é a do meio (PROVISÓRIO: confirmar).
## A metade esquerda (0..160) aparece na tela dividida; o resto é revelado na fusão da tela.

const WIDTH := 320
const MIGUEL_BED := Vector2(66, 96)


func _ready() -> void:
	_init_room(WIDTH, "wall_miguel")
	PropFactory.make_prop(world, "bed_made_a", Vector2(28, 96))
	add_sleeper_bed("bed_open", MIGUEL_BED, "miguel", -5.0)
	PropFactory.make_prop(world, "bed_made_b", Vector2(104, 96))
	add_clock_table(Vector2(140, 64))
	PropFactory.make_prop(world, "window_curtain", Vector2(66, 40))
	PropFactory.make_prop(world, "window_curtain", Vector2(240, 40))
	PropFactory.make_prop(world, "wardrobe", Vector2(190, 60))
	PropFactory.make_prop(world, "door_wood", Vector2(296, 48))

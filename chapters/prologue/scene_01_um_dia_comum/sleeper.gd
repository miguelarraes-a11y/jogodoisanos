class_name Sleeper
extends Sprite2D
## Pessoa na cama (sobreposta ao sprite da cama): dormindo -> olhos abertos -> sentada.
## Sheet: assets/sprites/characters/sleeper_<id>.png (72x30 px, 3 frames de 24x30).

const SLEEP := 0
const AWAKE := 1
const SIT := 2


func setup(character_id: String) -> void:
	texture = load("res://assets/sprites/characters/sleeper_%s.png" % character_id)
	hframes = 3
	centered = false
	offset = Vector2(-12, -30)
	frame = SLEEP


func set_state(state: int) -> void:
	frame = state

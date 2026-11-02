class_name Character
extends CharacterBody2D
## Personagem base: serve para jogador, NPC e personagens controlados por cutscene/IA.
## - Jogador: lê o teclado (se GameState.controls_locked for false).
## - NPC/cutscene/IA: defina `ai_direction` e `ai_running` de fora.

@export var character_id: String = "miguel"
@export var is_player: bool = false
@export var walk_speed: float = 44.0
@export var run_speed: float = 76.0

var facing: String = "down"
var ai_direction: Vector2 = Vector2.ZERO
var ai_running: bool = false
var sprite: AnimatedSprite2D
var sensor: Area2D

var _focused: Interactable = null

const SENSOR_OFFSETS := {
	"down": Vector2(0, 5),
	"up": Vector2(0, -14),
	"left": Vector2(-9, -6),
	"right": Vector2(9, -6),
}


func _ready() -> void:
	motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	collision_layer = 4 # Personagens ficam na camada 4
	collision_mask = 1  # Colidem com limites do mundo (camada 1), sem travar uns nos outros

	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = CharacterSprites.build(character_id)
	sprite.offset = Vector2(0, -12) # origem do nó = pés do personagem
	add_child(sprite)
	sprite.play("idle_down")

	var shape := CollisionShape2D.new()
	var rect := RectangleShape2D.new()
	rect.size = Vector2(6, 4)
	shape.shape = rect
	shape.position = Vector2(0, -2)
	add_child(shape)

	sensor = Area2D.new()
	sensor.collision_layer = 0
	sensor.collision_mask = 2
	sensor.monitorable = false
	sensor.monitoring = is_player
	var sensor_shape := CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 8.0
	sensor_shape.shape = circle
	sensor.add_child(sensor_shape)
	add_child(sensor)
	_update_sensor()


func set_player(value: bool) -> void:
	is_player = value
	sensor.set_deferred("monitoring", value)
	if not value:
		_set_focus(null)


func _physics_process(_delta: float) -> void:
	var dir := Vector2.ZERO
	var running := false
	if is_player:
		if not GameState.controls_locked:
			dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			running = Input.is_action_pressed("run")
	else:
		dir = ai_direction
		running = ai_running

	var speed := run_speed if running else walk_speed
	velocity = dir.normalized() * speed if dir.length() > 0.1 else Vector2.ZERO
	move_and_slide()
	_update_animation(dir, running)
	if is_player:
		_update_sensor()
		_update_focus()


func _update_animation(dir: Vector2, running: bool) -> void:
	var moving := dir.length() > 0.1
	if moving:
		if absf(dir.x) > absf(dir.y):
			facing = "right" if dir.x > 0.0 else "left"
		else:
			facing = "down" if dir.y > 0.0 else "up"
	sprite.play(("walk_" if moving else "idle_") + facing)
	sprite.speed_scale = 1.6 if (moving and running) else 1.0


func _update_sensor() -> void:
	sensor.position = SENSOR_OFFSETS[facing]


func _update_focus() -> void:
	var best: Interactable = null
	var best_dist := INF
	for area in sensor.get_overlapping_areas():
		if area is Interactable:
			var d: float = area.global_position.distance_to(global_position)
			if d < best_dist:
				best_dist = d
				best = area
	_set_focus(best)


func _set_focus(target: Interactable) -> void:
	if target == _focused:
		return
	if _focused != null and is_instance_valid(_focused):
		_focused.set_highlight(false)
	_focused = target
	if _focused != null:
		_focused.set_highlight(true)


func _unhandled_input(event: InputEvent) -> void:
	if not is_player or GameState.controls_locked:
		return
	if event.is_action_pressed("interact") and _focused != null:
		get_viewport().set_input_as_handled()
		_focused.interact(self)

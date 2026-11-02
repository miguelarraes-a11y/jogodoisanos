class_name BikeController
extends CharacterBody2D
## Controlador de bicicleta pixel art para passeios e corridas.
## Suporta controle manual do jogador (W/S/A/D/Setas/Espaço) e navegação autônoma por IA.

signal waypoint_reached(index: int)
signal finished_course

@export var bike_id: String = "miguel_bike"
@export var is_player: bool = false

var max_speed: float = 115.0
var boost_speed: float = 145.0
var acceleration: float = 130.0
var friction: float = 85.0
var brake_power: float = 200.0

var current_speed: float = 0.0
var move_direction: Vector2 = Vector2.RIGHT
var facing_dir: String = "right"
var controls_enabled: bool = true

# IA
var waypoints: Array[Vector2] = []
var current_waypoint_idx: int = 0
var follow_target: Node2D = null
var follow_offset: Vector2 = Vector2(28, 0)

var sprite: AnimatedSprite2D
var collision_shape: CollisionShape2D
var boost_cooldown: float = 0.0


func _ready() -> void:
	collision_layer = 4
	collision_mask = 1

	collision_shape = CollisionShape2D.new()
	var circle := CircleShape2D.new()
	circle.radius = 7.0
	collision_shape.shape = circle
	collision_shape.position = Vector2(0, 4)
	add_child(collision_shape)

	sprite = AnimatedSprite2D.new()
	sprite.sprite_frames = BikeSprites.build(bike_id)
	sprite.play("idle_right")
	add_child(sprite)


func _physics_process(delta: float) -> void:
	if boost_cooldown > 0.0:
		boost_cooldown -= delta

	if not controls_enabled:
		current_speed = move_toward(current_speed, 0.0, friction * delta)
		velocity = move_direction * current_speed
		_update_animation()
		move_and_slide()
		return

	if is_player:
		_process_player(delta)
	else:
		_process_ai(delta)

	velocity = move_direction * current_speed
	_update_animation()
	move_and_slide()


func _process_player(delta: float) -> void:
	var input_vec := Vector2.ZERO
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		input_vec.x -= 1.0
	if Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		input_vec.x += 1.0
	if Input.is_action_pressed("move_up") or Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		input_vec.y -= 1.0
	if Input.is_action_pressed("move_down") or Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		input_vec.y += 1.0

	var has_input := input_vec.length_squared() > 0.01

	if has_input:
		var target_dir := input_vec.normalized()
		# Redução sutil de velocidade em curvas fechadas
		var dot := move_direction.dot(target_dir)
		if dot < 0.3 and current_speed > 40.0:
			current_speed *= 0.94

		move_direction = move_direction.lerp(target_dir, 12.0 * delta).normalized()

		# Impulso de pedalada (Espaço)
		var is_boosting := (Input.is_key_pressed(KEY_SPACE) or Input.is_action_pressed("confirm")) and boost_cooldown <= 0.0
		var top := boost_speed if is_boosting else max_speed

		current_speed = move_toward(current_speed, top, acceleration * delta)
		if is_boosting:
			boost_cooldown = 1.2
	else:
		current_speed = move_toward(current_speed, 0.0, friction * delta)

	_update_facing_dir(move_direction)


func _process_ai(delta: float) -> void:
	var target_pos := global_position

	if not waypoints.is_empty():
		if current_waypoint_idx < waypoints.size():
			target_pos = waypoints[current_waypoint_idx]
			var dist := global_position.distance_to(target_pos)
			if dist < 24.0:
				waypoint_reached.emit(current_waypoint_idx)
				current_waypoint_idx += 1
				if current_waypoint_idx >= waypoints.size():
					finished_course.emit()
					current_speed = move_toward(current_speed, 0.0, friction * delta)
					return
		else:
			current_speed = move_toward(current_speed, 0.0, friction * delta)
			return
	elif follow_target != null and is_instance_valid(follow_target):
		target_pos = follow_target.global_position + follow_offset

	var to_target := target_pos - global_position
	var dist := to_target.length()

	if dist > 8.0:
		var desired_dir := to_target.normalized()
		move_direction = move_direction.lerp(desired_dir, 10.0 * delta).normalized()
		# Ajusta velocidade para ficar emparelhado e competitivo
		var target_speed := clampf(dist * 1.5, 60.0, max_speed + randf_range(-5.0, 5.0))
		current_speed = move_toward(current_speed, target_speed, acceleration * delta)
	else:
		current_speed = move_toward(current_speed, 0.0, friction * 2.0 * delta)

	_update_facing_dir(move_direction)


func _update_facing_dir(dir: Vector2) -> void:
	if dir.length_squared() < 0.05:
		return
	if abs(dir.x) >= abs(dir.y):
		facing_dir = "right" if dir.x > 0 else "left"
	else:
		facing_dir = "down" if dir.y > 0 else "up"


func _update_animation() -> void:
	if sprite == null or sprite.sprite_frames == null:
		return

	if current_speed > 8.0:
		var anim := "pedal_" + facing_dir
		if sprite.animation != anim:
			sprite.play(anim)
		var speed_scale := clampf(current_speed / 80.0, 0.6, 1.8)
		sprite.speed_scale = speed_scale
	else:
		var anim := "idle_" + facing_dir
		if sprite.animation != anim:
			sprite.play(anim)
		sprite.speed_scale = 1.0


func ring_bell() -> void:
	AudioManager.play_sfx("bike_bell", -2.0)

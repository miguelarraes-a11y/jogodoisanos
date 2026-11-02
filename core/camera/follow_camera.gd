class_name FollowCamera
extends Camera2D
## Câmera que segue um alvo com suavidade e respeita os limites do cenário.

@export var follow_speed: float = 10.0
var target: Node2D


func set_world_limits(rect: Rect2i) -> void:
	limit_left = rect.position.x
	limit_top = rect.position.y
	limit_right = rect.end.x
	limit_bottom = rect.end.y


func snap_to_target() -> void:
	if target != null:
		global_position = target.global_position + Vector2(0, -10)


func _process(delta: float) -> void:
	if target == null:
		return
	var goal := target.global_position + Vector2(0, -10)
	global_position = global_position.lerp(goal, 1.0 - exp(-follow_speed * delta))

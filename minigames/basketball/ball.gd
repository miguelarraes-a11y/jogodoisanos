class_name Ball
extends Node2D
## Bola com posição no chão (plan) e altura (z). A sombra fica no chão e o sprite sobe com z.

var sprite: Sprite2D
var height: float = 0.0


func _ready() -> void:
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/sprites/ball.png")
	add_child(sprite)
	set_state(position, 0.0)


func set_state(plan: Vector2, z: float) -> void:
	position = plan
	height = z
	if sprite:
		sprite.position = Vector2(0, -z - 1)
	queue_redraw()


func _draw() -> void:
	draw_set_transform(Vector2.ZERO, 0.0, Vector2(1.0, 0.5))
	draw_circle(Vector2.ZERO, maxf(1.5, 3.5 - height * 0.03), Color(0, 0, 0, 0.30))

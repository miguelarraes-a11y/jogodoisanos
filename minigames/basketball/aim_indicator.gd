class_name AimIndicator
extends Node2D
## Linha pontilhada de mira no chão, círculo-alvo sob a cesta e marcador de onde a bola cairia.

var origin: Vector2
var angle: float = 0.0
var length: float = 130.0
var power: float = -1.0
var hoop: Vector2
var radius: float = 9.0


func set_state(p_origin: Vector2, p_angle: float, p_length: float, p_power: float, p_hoop: Vector2, p_radius: float) -> void:
	origin = p_origin; angle = p_angle; length = p_length; power = p_power; hoop = p_hoop; radius = p_radius
	queue_redraw()


func _draw() -> void:
	draw_arc(hoop, radius, 0.0, TAU, 20, Color(0.45, 0.9, 0.5, 0.9), 1.0)
	var dir := Vector2(sin(angle), -cos(angle))
	for i in range(1, int(length / 6.0) + 1):
		draw_rect(Rect2(origin + dir * 6.0 * i - Vector2(0.5, 0.5), Vector2(1, 1)), Color(1, 1, 1, 0.7))
	if power >= 0.0:
		var m := origin + dir * length * power
		var gold := Color(1.0, 0.85, 0.3)
		draw_arc(m, 2.5, 0.0, TAU, 10, gold, 1.0)
		draw_rect(Rect2(m - Vector2(0.5, 0.5), Vector2(1, 1)), gold)

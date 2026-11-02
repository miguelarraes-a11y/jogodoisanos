class_name BusActor
extends Node2D
## Ator de ônibus urbano brasileiro em pixel art.
## Gerencia deslocamento do veículo, parada no ponto, abertura e fechamento de portas.

var sprite: Sprite2D
var door_open: bool = false
var engine_sfx: AudioStreamPlayer


func _init() -> void:
	name = "BusActor"
	sprite = Sprite2D.new()
	sprite.texture = load("res://assets/tiles/bus_urban.png")
	sprite.centered = true
	add_child(sprite)


func arrive_at(target_pos: Vector2, duration: float = 2.5) -> Signal:
	engine_sfx = AudioManager.play_sfx("bus_engine", -4.0, true)
	var tw := create_tween()
	tw.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tw.finished.connect(func():
		if engine_sfx != null:
			AudioManager.stop_player(engine_sfx, 0.4)
	)
	return tw.finished


func depart_to(target_pos: Vector2, duration: float = 2.5) -> Signal:
	engine_sfx = AudioManager.play_sfx("bus_engine", -4.0, true)
	var tw := create_tween()
	tw.tween_property(self, "position", target_pos, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tw.finished.connect(func():
		if engine_sfx != null:
			AudioManager.stop_player(engine_sfx, 0.5)
	)
	return tw.finished


func open_doors() -> void:
	door_open = true
	# Feedback sonoro de freio a ar e portas abrindo
	AudioManager.play_sfx("swish", -6.0)


func close_doors() -> void:
	door_open = false
	AudioManager.play_sfx("swish", -6.0)

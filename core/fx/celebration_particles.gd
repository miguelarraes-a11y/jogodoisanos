class_name CelebrationParticles
extends Node2D
## Sistema de partículas comemorativas: Corações em pixel art, estrelas brilhantes e confetes coloridos.
## Usado na celebração do pedido de namoro e nos momentos marcantes.

var heart_tex: Texture2D
var star_tex: Texture2D
var confetti_tex: Texture2D

var is_active: bool = false
var spawn_timer: float = 0.0
var intensity: float = 1.0


func _init() -> void:
	name = "CelebrationParticles"
	heart_tex = load("res://assets/sprites/ui/pixel_heart.png")
	star_tex = load("res://assets/sprites/ui/pixel_star.png")
	confetti_tex = load("res://assets/sprites/ui/confetti.png")


func start_burst(burst_intensity: float = 1.0) -> void:
	is_active = true
	intensity = burst_intensity
	AudioManager.play_sfx("sparkle", 1.0)
	# Dispara primeira salva de partículas ao redor do ponto de origem
	for i in 16:
		_spawn_particle(randf_range(-40.0, 40.0), randf_range(-10.0, 10.0))


func stop_burst() -> void:
	is_active = false


func _process(delta: float) -> void:
	if not is_active:
		return
	spawn_timer += delta
	var interval := 0.08 / maxf(0.1, intensity)
	if spawn_timer >= interval:
		spawn_timer = 0.0
		_spawn_particle(randf_range(-140.0, 140.0), randf_range(-60.0, 40.0))


func _spawn_particle(offset_x: float, offset_y: float) -> void:
	var type := randi() % 3
	var p := Sprite2D.new()

	match type:
		0:
			p.texture = heart_tex
			p.scale = Vector2(randf_range(0.9, 1.3), randf_range(0.9, 1.3))
		1:
			p.texture = star_tex
			p.scale = Vector2(randf_range(0.8, 1.2), randf_range(0.8, 1.2))
		2:
			p.texture = confetti_tex
			p.scale = Vector2(randf_range(1.0, 1.5), randf_range(1.0, 1.5))
			p.rotation = randf_range(0.0, TAU)

	p.position = Vector2(offset_x, offset_y)
	p.modulate = Color(1.0, 1.0, 1.0, 0.0)
	add_child(p)

	# Trajetória e animação suave de subida/flutuação
	var tw := p.create_tween()
	var rise_y := randf_range(30.0, 75.0)
	var drift_x := randf_range(-15.0, 15.0)
	var lifetime := randf_range(1.8, 2.8)

	tw.set_parallel(true)
	tw.tween_property(p, "position:y", p.position.y - rise_y, lifetime).set_trans(Tween.TRANS_SINE)
	tw.tween_property(p, "position:x", p.position.x + drift_x, lifetime).set_trans(Tween.TRANS_SINE)
	tw.tween_property(p, "modulate:a", 1.0, 0.4)
	tw.tween_property(p, "modulate:a", 0.0, 0.6).set_delay(lifetime - 0.6)

	if type == 1:
		tw.tween_property(p, "rotation", TAU, lifetime)
	elif type == 2:
		tw.tween_property(p, "rotation", p.rotation + randf_range(-2.0, 2.0), lifetime)

	tw.chain().tween_callback(p.queue_free)

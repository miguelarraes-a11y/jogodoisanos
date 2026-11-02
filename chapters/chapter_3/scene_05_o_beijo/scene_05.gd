extends Node
## CAPÍTULO 3 — CENA 05: O BEIJO
## O momento mais marcante do capítulo: depois da foto e das risadas, o ritmo desacelera.
## Um beijo verdadeiro, demorado, romântico e delicado que marca o relacionamento dos dois.

const GOLDEN_WARMTH := Color(1.0, 0.90, 0.82)
const NEXT_SCENE := "res://chapters/chapter_3/scene_06_caminhada_avo/scene_06.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character
var bench: StaticBody2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
	GameState.scene_id = "scene_05"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_closer_to_you", 1.0, -4.0)

	var park := Node2D.new()
	stage.add_child(park)

	PropFactory.make_ground(park, "grass", Rect2(0, 0, 320, 180), -4)
	PropFactory.make_ground(park, "sidewalk", Rect2(120, 140, 80, 40), -3)

	world = Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	PropFactory.make_prop(world, "tree", Vector2(70, 75))
	PropFactory.make_prop(world, "tree", Vector2(250, 75))
	PropFactory.make_prop(world, "tree", Vector2(160, 50))

	bench = PropFactory.make_prop(world, "banco_pedra", Vector2(160, 102))

	var light := CanvasModulate.new()
	light.color = GOLDEN_WARMTH
	stage.add_child(light)

	# Miguel e Maria sentados próximos no banco de pedra
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(156, 98)
	world.add_child(miguel)
	runner.face(miguel, "right")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(164, 98)
	world.add_child(maria)
	runner.face(maria, "left")

	camera.target = miguel
	camera.position = Vector2(160, 95)
	camera.zoom = Vector2(1.35, 1.35)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(0.6)
	await runner.wait(0.5)

	# 1. A conversa desacelera e o clima fica mais íntimo
	await runner.say(["c3_s5_silencio_intimo"])
	await runner.wait(0.5)
	await runner.say(["c3_s5_maria_olhar"])
	await runner.wait(0.8)

	# 2. Aproximação gradual e enquadramento próximo
	var zoom_in := create_tween()
	zoom_in.tween_property(camera, "zoom", Vector2(1.65, 1.65), 1.5).set_trans(Tween.TRANS_SINE)
	zoom_in.parallel().tween_property(camera, "position", Vector2(160, 93), 1.5)

	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(158, 98)),
		runner.walk_to.bind(maria, Vector2(162, 98))
	])
	runner.face(miguel, "right")
	runner.face(maria, "left")

	await zoom_in.finished
	await runner.wait(0.6)

	# 3. O Beijo de verdade: dura bastante tempo, com intensidade e doçura
	AudioManager.play_sfx("kiss_chime", -2.0)
	_spawn_kiss_hearts(Vector2(160, 84))

	await runner.say(["c3_s5_beijo_narracao"])
	await runner.wait(3.5) # Duração marcante e carinhosa do beijo

	# 4. Afastamento suave mantendo os olhares conectados
	var zoom_out := create_tween()
	zoom_out.tween_property(camera, "zoom", Vector2(1.35, 1.35), 1.5).set_trans(Tween.TRANS_SINE)
	zoom_out.parallel().tween_property(camera, "position", Vector2(160, 95), 1.5)

	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(155, 98)),
		runner.walk_to.bind(maria, Vector2(165, 98))
	])
	runner.face(miguel, "right")
	runner.face(maria, "left")

	await zoom_out.finished
	await runner.wait(0.6)

	# 5. Emoção pós-beijo
	await runner.say(["c3_s5_pos_beijo_maria"])
	await runner.wait(0.4)
	await runner.say(["c3_s5_pos_beijo_miguel"])
	await runner.wait(1.2)

	await runner.fade_black(1.5)
	SceneManager.change_scene(NEXT_SCENE, 0.4)


## Efeito dos corações flutuando durante o beijo
func _spawn_kiss_hearts(origin: Vector2) -> void:
	var heart_tex: Texture2D = load("res://assets/sprites/ui/pixel_heart.png")
	for i in 8:
		var delay: float = i * 0.35
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_instance_valid(world):
				return
			var heart := Sprite2D.new()
			heart.texture = heart_tex
			heart.z_index = 30
			heart.position = origin + Vector2(randf_range(-8.0, 8.0), randf_range(-3.0, 3.0))
			heart.scale = Vector2(0.3, 0.3)
			heart.modulate = Color(1.0, 1.0, 1.0, 0.0)
			world.add_child(heart)

			var tw := create_tween().set_parallel(true)
			var target_y := heart.position.y - randf_range(28.0, 44.0)
			var target_x := heart.position.x + randf_range(-12.0, 12.0)
			var duration := randf_range(2.0, 2.6)

			tw.tween_property(heart, "position:y", target_y, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tw.tween_property(heart, "position:x", target_x, duration).set_trans(Tween.TRANS_SINE)

			var s_tw := create_tween()
			s_tw.tween_property(heart, "scale", Vector2(1.1, 1.1), 0.4)
			s_tw.tween_property(heart, "scale", Vector2(1.25, 1.25), duration * 0.4)
			s_tw.tween_property(heart, "scale", Vector2(0.9, 0.9), duration * 0.3)

			var a_tw := create_tween()
			a_tw.tween_property(heart, "modulate:a", 1.0, 0.3)
			a_tw.tween_interval(duration * 0.45)
			a_tw.tween_property(heart, "modulate:a", 0.0, duration * 0.35)
			await a_tw.finished

			if is_instance_valid(heart):
				heart.queue_free()
		)

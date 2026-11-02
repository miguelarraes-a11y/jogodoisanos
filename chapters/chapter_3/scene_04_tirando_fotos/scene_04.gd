extends Node
## CAPÍTULO 3 — CENA 04: TIRANDO FOTOS NO BANCO DE PEDRA
## Maria Fernanda e Miguel tiram uma selfie juntos.
## Minigame interativo de fotografia revelando a foto lembrança Polaroid do casal!

const NEXT_SCENE := "res://chapters/chapter_3/scene_05_o_beijo/scene_05.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var bench: StaticBody2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
	GameState.scene_id = "scene_04"

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

	var world := Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	PropFactory.make_prop(world, "tree", Vector2(70, 75))
	PropFactory.make_prop(world, "tree", Vector2(250, 75))
	PropFactory.make_prop(world, "tree", Vector2(160, 50))

	bench = PropFactory.make_prop(world, "banco_pedra", Vector2(160, 102))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	# Miguel e Maria já sentados no banco de pedra
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(152, 98)
	world.add_child(miguel)
	runner.face(miguel, "right")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(168, 98)
	world.add_child(maria)
	runner.face(maria, "left")

	camera.target = miguel
	camera.position = Vector2(160, 95)
	camera.zoom = Vector2(1.35, 1.35)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(0.6)
	await runner.wait(0.4)

	# Ideia de tirar foto
	await runner.say(["c3_s4_ideia_foto"])
	await runner.wait(0.3)
	await runner.say(["c3_s4_miguel_topa"])
	await runner.wait(0.3)

	# Eles se inclinam bem juntinhos no banco de pedra para a selfie
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(156, 98)),
		runner.walk_to.bind(maria, Vector2(164, 98))
	])
	runner.face(miguel, "down")
	runner.face(maria, "down")
	await runner.wait(0.4)

	await runner.say(["c3_s4_maria_ajeita"])
	await runner.wait(0.4)

	# Dispara o minigame de foto
	var photo_game := PhotoMinigame.new()
	add_child(photo_game)
	var photo_result: Dictionary = await photo_game.run()
	GameState.set_flag("selfie_taken", true)
	photo_game.queue_free()

	await runner.wait(0.6)

	# Reação fofa à foto tirada
	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.say(["c3_s4_foto_sucesso"])
	await runner.wait(0.3)
	await runner.say(["c3_s4_miguel_gostou"])
	await runner.wait(0.8)

	# Transição suave para o beijo
	SceneManager.change_scene(NEXT_SCENE, 0.4)

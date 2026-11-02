extends Node
## CAPÍTULO 4 — CENA 04: CHEGADA AO PARQUE DE EXPOSIÇÕES DE ITAIPAVA
## Cenário inspirado na foto real do Parque de Exposições: pista asfaltada com faixas tracejadas,
## gramados amplos, árvores frondosas, quiosque de madeira e montanhas serranas ao fundo.

const NEXT_SCENE := "res://chapters/chapter_4/scene_05_passeio_bicicleta/scene_05.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	AudioManager.play_music("music_park_ride", 1.0, -3.0)

	var park := Node2D.new()
	stage.add_child(park)

	# Fundo com montanhas de Petrópolis
	var mtn := Sprite2D.new()
	mtn.texture = load("res://assets/tiles/mountain_bg.png")
	mtn.position = Vector2(240, 45)
	mtn.z_index = -35
	park.add_child(mtn)

	# Gramado amplo do parque
	PropFactory.make_ground(park, "grass", Rect2(0, 0, 480, 360), -30)

	# Pista asfaltada com faixas brancas tracejadas para ciclistas e pedestres
	PropFactory.make_ground(park, "asphalt_bike_lane", Rect2(0, 140, 480, 64), -29)

	world = Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	# Árvores frondosas e quiosque de madeira (referência fiel à foto de Itaipava)
	PropFactory.make_prop(world, "kiosk_wood", Vector2(380, 120))
	PropFactory.make_prop(world, "tree_parque", Vector2(60, 125))
	PropFactory.make_prop(world, "tree_parque", Vector2(170, 118))
	PropFactory.make_prop(world, "tree_parque", Vector2(290, 122))
	PropFactory.make_prop(world, "tree_parque", Vector2(430, 126))

	PropFactory.make_prop(world, "tree_parque", Vector2(100, 245))
	PropFactory.make_prop(world, "tree_parque", Vector2(240, 250))
	PropFactory.make_prop(world, "tree_parque", Vector2(370, 248))

	# Luz agradável e ensolarada
	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.99, 0.94)
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(30, 165)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(15, 175)
	world.add_child(maria)

	camera.target = miguel
	camera.position = Vector2(100, 170)
	camera.set_world_limits(Rect2i(0, 0, 480, 360))

	await runner.fade_from_black(1.0)
	await runner.wait(0.4)

	# Caminham juntos entrando no parque
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(140, 165)),
		runner.walk_to.bind(maria, Vector2(125, 175))
	])
	runner.face(miguel, "down")
	runner.face(maria, "right")
	await runner.wait(0.4)

	await runner.say(["c4_s4_vista_parque"])
	await runner.wait(0.3)
	await runner.say(["c4_s4_miguel_bikes"])
	await runner.wait(0.3)
	await runner.say(["c4_s4_maria_animada"])
	await runner.wait(0.5)

	# Caminham em direção às bicicletas
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(200, 165)),
		runner.walk_to.bind(maria, Vector2(185, 175))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

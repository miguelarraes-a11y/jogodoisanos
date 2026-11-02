extends Node
## CAPÍTULO 3 — CENA 02: O NOVO ENCONTRO
## Miguel e Maria Fernanda se encontram novamente no bairro.
## O clima agora é muito mais leve, descontraído e próximo do que no primeiro encontro.

const AFTERNOON_LIGHT := Color(1.0, 0.96, 0.90)
const NEXT_SCENE := "res://chapters/chapter_3/scene_03_banco_de_pedra/scene_03.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
	GameState.scene_id = "scene_02"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_closer_to_you", 1.5, -3.0)

	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	var light := CanvasModulate.new()
	light.color = AFTERNOON_LIGHT
	stage.add_child(light)

	# Miguel aguardando perto da praça
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 300)
	world.add_child(miguel)
	runner.face(miguel, "down")

	# Maria chegando radiante com seus óculos dourados
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(188, 380)
	world.add_child(maria)
	runner.face(maria, "up")

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Maria caminha até o Miguel
	await runner.walk_to(maria, Vector2(188, 320))
	runner.face(maria, "up")
	runner.face(miguel, "down")
	await runner.wait(0.6)

	# Cumprimento afetuoso e à vontade
	await runner.say(["c3_s2_miguel_oi"])
	await runner.wait(0.3)
	await runner.say(["c3_s2_maria_oi"])
	await runner.wait(0.4)
	await runner.say(["c3_s2_miguel_caminho"])
	await runner.wait(0.3)
	await runner.say(["c3_s2_maria_vamos"])
	await runner.wait(0.5)

	# Caminham juntos em direção à praça do banco de pedra
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 240)),
		runner.walk_to.bind(maria, Vector2(204, 242))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

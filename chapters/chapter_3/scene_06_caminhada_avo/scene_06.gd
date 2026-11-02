extends Node
## CAPÍTULO 3 — CENA 06: CAMINHANDO ATÉ A CASA DA AVÓ
## Após o beijo no banco de pedra, Miguel acompanha Maria Fernanda até a casa da avó dela.
## Caminhada tranquila sob a luz suave do entardecer com cumplicidade e carinho.

const DUSK_LIGHT := Color(0.75, 0.70, 0.85)
const NEXT_SCENE := "res://chapters/chapter_3/scene_07_despedida_avo/scene_07.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
	GameState.scene_id = "scene_06"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	var light := CanvasModulate.new()
	light.color = DUSK_LIGHT
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 380)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(204, 382)
	world.add_child(maria)

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Caminham juntos pela calçada
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 250)),
		runner.walk_to.bind(maria, Vector2(204, 252))
	])

	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.wait(0.4)

	# Diálogo carinhoso
	await runner.say(["c3_s6_tarde_fim"])
	await runner.wait(0.3)
	await runner.say(["c3_s6_miguel_acompanha"])
	await runner.wait(0.3)
	await runner.say(["c3_s6_maria_sorriso"])
	await runner.wait(0.6)

	# Continuam caminhando até o portão da avó
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 160)),
		runner.walk_to.bind(maria, Vector2(204, 162))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

extends Node
## CAPÍTULO 2 — CENA 06: CAMINHANDO ATÉ A QUADRA
## Transição cinematográfica: Miguel e Maria caminham juntos com a luz dourada do fim de tarde.
## A timidez deu lugar a uma sintonia natural e carinhosa.

const GOLDEN_HOUR := Color(1.0, 0.86, 0.70)
const NEXT_SCENE := "res://chapters/chapter_2/scene_07_aula_basquete/scene_07.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
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
	light.color = GOLDEN_HOUR
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 140)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(204, 142)
	world.add_child(maria)

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.4)

	# Caminham juntos pela calçada iluminada pelo sol poente
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 280)),
		runner.walk_to.bind(maria, Vector2(204, 282))
	])

	runner.face(miguel, "right")
	runner.face(maria, "left")
	await runner.wait(0.5)

	# Diálogo suave a caminho da quadra
	await runner.say(["c2_s7_chegada"])
	await runner.wait(0.5)

	# Entram juntos pelo portão da quadra
	runner.face(miguel, "down")
	runner.face(maria, "down")
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 340)),
		runner.walk_to.bind(maria, Vector2(204, 342))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

extends Node
## CAPÍTULO 2 — CENA 08: CAMINHANDO ATÉ A CASA DA AVÓ
## O início da noite cai sobre o bairro. Os postes começam a acender.
## Miguel acompanha Maria Fernanda com carinho e tranquilidade até a casa da avó dela.

const NIGHT_FALL := Color(0.60, 0.60, 0.78)
const NEXT_SCENE := "res://chapters/chapter_2/scene_09_despedida/scene_09.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
	GameState.scene_id = "scene_08"

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

	# Luz da noite inicial
	var light := CanvasModulate.new()
	light.color = NIGHT_FALL
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

	# Caminham devagar pela calçada
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 260)),
		runner.walk_to.bind(maria, Vector2(204, 262))
	])

	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.wait(0.4)

	# Diálogo de carinho e cuidado
	await runner.say(["c2_s8_noite"])
	await runner.wait(0.3)
	await runner.say(["c2_s8_miguel_acompanha"])
	await runner.wait(0.3)
	await runner.say(["c2_s8_maria_obrigada"])
	await runner.wait(0.6)

	# Continuam até a esquina da casa da avó
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 160)),
		runner.walk_to.bind(maria, Vector2(204, 162))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

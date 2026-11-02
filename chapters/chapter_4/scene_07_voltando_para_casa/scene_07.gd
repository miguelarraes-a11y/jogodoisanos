extends Node
## CAPÍTULO 4 — CENA 07: VOLTANDO PARA CASA
## Fim de tarde no Parque de Exposições, retorno de ônibus para o bairro
## e despedida carinhosa com sentimento de um dia inesquecível.

const NEXT_SCENE := "res://chapters/chapter_4/scene_08_passagem_tempo/scene_08.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character
var bus: BusActor


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
	GameState.scene_id = "scene_07"

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

	world = Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Ponto de ônibus no bairro
	PropFactory.make_prop(world, "bus_stop", Vector2(175, 230))

	# Luz de crepúsculo alaranjada
	var light := CanvasModulate.new()
	light.color = Color(0.88, 0.68, 0.58)
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(190, 240)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(175, 240)
	world.add_child(maria)

	bus = BusActor.new()
	bus.position = Vector2(240, 245)
	world.add_child(bus)

	camera.target = miguel
	camera.position = Vector2(190, 240)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.4)

	# Chegando do retorno do ônibus
	runner.face(miguel, "left")
	runner.face(maria, "right")
	await runner.wait(0.5)

	# Ônibus segue viagem após o desembarque deles
	bus.depart_to(Vector2(240, 50), 2.2)
	await runner.wait(0.8)

	await runner.say(["c4_s7_fim_tarde"])
	await runner.wait(0.3)
	await runner.say(["c4_s7_despedida_onibus"])
	await runner.wait(0.3)
	await runner.say(["c4_s7_maria_carinho"])
	await runner.wait(0.6)

	# Abraço carinhoso de despedida
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(184, 240)),
		runner.walk_to.bind(maria, Vector2(180, 240))
	])
	await runner.wait(1.2)

	# Cada um segue em direção à sua casa
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 300)),
		runner.walk_to.bind(maria, Vector2(175, 180))
	])

	await runner.fade_black(1.5)
	SceneManager.change_scene(NEXT_SCENE, 0.4)

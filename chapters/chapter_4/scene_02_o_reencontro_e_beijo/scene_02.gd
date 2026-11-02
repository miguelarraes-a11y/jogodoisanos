extends Node
## CAPÍTULO 4 — CENA 02: O REENCONTRO E O BEIJO
## Ponto de ônibus no bairro de Petrópolis.
## Miguel espera, Maria Fernanda chega; cumprimento com beijo breve, natural e carinhoso (sem exageros).
## O ônibus urbano chega e os dois embarcam juntos.

const NEXT_SCENE := "res://chapters/chapter_4/scene_03_viagem_onibus/scene_03.tscn"

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
	var street := Node2D.new()
	stage.add_child(street)

	world = Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Ponto de ônibus na calçada esquerda (x=175, y=230)
	PropFactory.make_prop(world, "bus_stop", Vector2(175, 230))

	# Luz agradável de início de tarde
	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.98, 0.92)
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 240)
	world.add_child(miguel)
	runner.face(miguel, "down")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(188, 330)
	world.add_child(maria)

	# Ônibus começa fora da tela na rua de baixo
	bus = BusActor.new()
	bus.position = Vector2(240, 480)
	world.add_child(bus)

	camera.target = miguel
	camera.position = Vector2(195, 240)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Pensamento inicial de Miguel
	await runner.say(["c4_s2_miguel_chegada"])
	await runner.wait(0.5)

	# Maria se aproxima subindo a calçada
	runner.face(maria, "up")
	await runner.walk_to(maria, Vector2(188, 256))
	await runner.wait(0.3)

	# Cumprimento
	await runner.say(["c4_s2_maria_oi"])
	runner.face(miguel, "down")
	await runner.say(["c4_s2_miguel_oi"])

	# Aproximação e beijo carinhoso, natural e breve (sem corações flutuantes)
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 246)),
		runner.walk_to.bind(maria, Vector2(188, 250))
	])
	runner.face(miguel, "down")
	runner.face(maria, "up")

	AudioManager.play_sfx("kiss_chime", -8.0)
	await runner.say(["c4_s2_beijo_narracao"])
	await runner.wait(1.4)

	# Ficam lado a lado na calçada conversando
	await runner.walk_to(maria, Vector2(180, 244))
	runner.face(maria, "right")
	runner.face(miguel, "left")
	await runner.wait(0.6)

	# Chegada do ônibus urbano
	await bus.arrive_at(Vector2(240, 245), 2.8)
	bus.open_doors()
	await runner.wait(0.4)

	# Avisam que o ônibus chegou
	await runner.say(["c4_s2_onibus_chegando"])
	await runner.say(["c4_s2_maria_vamos"])
	await runner.wait(0.3)

	# Embarcam pela porta dianteira do ônibus
	runner.face(maria, "right")
	runner.face(miguel, "right")
	await runner.walk_to(maria, Vector2(216, 245))
	maria.visible = false
	await runner.walk_to(miguel, Vector2(216, 245))
	miguel.visible = false

	bus.close_doors()
	await runner.wait(0.5)

	# Ônibus parte
	bus.depart_to(Vector2(240, 50), 2.2)
	await runner.wait(1.0)

	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.4)

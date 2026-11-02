extends Node
## CAPÍTULO 4 — CENA 06: MINIGAME — CORRIDA DE BICICLETA
## Miguel vs Maria Fernanda numa divertida corrida de bicicleta pelo Parque de Exposições.
## Linha de partida, contagem 3-2-1-JÁ, HUD completo, curvas, retas e linha de chegada.
## A vitória de qualquer um permite a continuidade normal da história.

const NEXT_SCENE := "res://chapters/chapter_4/scene_07_voltando_para_casa/scene_07.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var player_bike: BikeController
var maria_bike: BikeController
var minigame: BikeRaceMinigame


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	var park := Node2D.new()
	stage.add_child(park)

	# Fundo com montanhas de Petrópolis
	var mtn := Sprite2D.new()
	mtn.texture = load("res://assets/tiles/mountain_bg.png")
	mtn.position = Vector2(400, 45)
	mtn.z_index = -35
	park.add_child(mtn)

	# Pista ampla do circuito de corrida (800x400)
	PropFactory.make_ground(park, "grass", Rect2(0, 0, 800, 400), -30)
	PropFactory.make_ground(park, "asphalt_bike_lane", Rect2(0, 160, 800, 80), -29)

	world = Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	# Árvores delimitando as margens do circuito
	for i in 8:
		var tx := 30 + i * 105
		PropFactory.make_prop(world, "tree_parque", Vector2(tx, 140), Vector2(10, 8))
		PropFactory.make_prop(world, "tree_parque", Vector2(tx + 25, 270), Vector2(10, 8))

	# Linha de largada com bandeiras quadriculadas
	var flag_start_1 := Sprite2D.new()
	flag_start_1.texture = load("res://assets/sprites/ui/race_flag.png")
	flag_start_1.position = Vector2(75, 160)
	world.add_child(flag_start_1)

	var flag_start_2 := Sprite2D.new()
	flag_start_2.texture = load("res://assets/sprites/ui/race_flag.png")
	flag_start_2.position = Vector2(75, 240)
	world.add_child(flag_start_2)

	# Linha de chegada com bandeiras quadriculadas
	var flag_finish_1 := Sprite2D.new()
	flag_finish_1.texture = load("res://assets/sprites/ui/race_flag.png")
	flag_finish_1.position = Vector2(720, 160)
	world.add_child(flag_finish_1)

	var flag_finish_2 := Sprite2D.new()
	flag_finish_2.texture = load("res://assets/sprites/ui/race_flag.png")
	flag_finish_2.position = Vector2(720, 240)
	world.add_child(flag_finish_2)

	# Quiosque no fim da reta
	PropFactory.make_prop(world, "kiosk_wood", Vector2(750, 135))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.99, 0.94)
	stage.add_child(light)

	# Bicicletas posicionadas lado a lado na largada
	player_bike = BikeController.new()
	player_bike.bike_id = "miguel_bike"
	player_bike.is_player = true
	player_bike.position = Vector2(70, 185)
	world.add_child(player_bike)

	maria_bike = BikeController.new()
	maria_bike.bike_id = "maria_bike"
	maria_bike.is_player = false
	maria_bike.position = Vector2(70, 215)
	world.add_child(maria_bike)

	camera.target = player_bike
	camera.position = Vector2(100, 200)
	camera.set_world_limits(Rect2i(0, 0, 800, 400))

	# Waypoints do percurso para a IA
	var circuit_waypoints: Array[Vector2] = [
		Vector2(180, 215),
		Vector2(320, 200),
		Vector2(460, 215),
		Vector2(600, 200),
		Vector2(730, 200)
	]

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Diálogo de desafio amigável
	await runner.say(["c4_s6_desafio_maria"])
	await runner.wait(0.3)
	await runner.say(["c4_s6_miguel_aceita"])
	await runner.wait(0.5)

	# Inicia o minigame de corrida
	minigame = BikeRaceMinigame.new()
	add_child(minigame)
	minigame.setup_racers(player_bike, maria_bike, circuit_waypoints)

	await minigame.start_countdown()

	# Espera o fim da corrida
	var winner_name: String = await minigame.race_finished

	# Pós-corrida: desaceleração e conversa animada
	AudioManager.play_music("music_park_ride", 1.5, -4.0)
	await runner.wait(1.0)

	await runner.say(["c4_s6_pos_corrida_maria"])
	await runner.wait(0.3)
	await runner.say(["c4_s6_pos_corrida_miguel"])
	await runner.wait(1.0)

	# Transição suave para o retorno
	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.4)

extends Node
## CAPÍTULO 4 — CENA 05: PASSEIO DE BICICLETA
## Gameplay: O jogador controla Miguel andando de bicicleta pela ciclovia do Parque de Exposições.
## Maria Fernanda pedala ao lado acompanhando com IA amigável.

const NEXT_SCENE := "res://chapters/chapter_4/scene_06_corrida_bicicleta/scene_06.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var player_bike: BikeController
var maria_bike: BikeController
var hud_layer: CanvasLayer

var dialogue_shown_1: bool = false
var dialogue_shown_2: bool = false
var transitioning: bool = false


func _ready() -> void:
	GameState.controls_locked = false
	GameState.chapter_id = "chapter_4"
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
	AudioManager.play_music("music_park_ride", 1.0, -3.0)

	var park := Node2D.new()
	stage.add_child(park)

	# Fundo serrano
	var mtn := Sprite2D.new()
	mtn.texture = load("res://assets/tiles/mountain_bg.png")
	mtn.position = Vector2(320, 50)
	mtn.z_index = -35
	park.add_child(mtn)

	# Gramado e ciclovia ampla (640x360)
	PropFactory.make_ground(park, "grass", Rect2(0, 0, 640, 360), -30)
	PropFactory.make_ground(park, "asphalt_bike_lane", Rect2(0, 140, 640, 70), -29)

	world = Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	# Árvores ao longo da pista
	for i in 6:
		var tx := 40 + i * 110
		PropFactory.make_prop(world, "tree_parque", Vector2(tx, 122), Vector2(10, 8))
		PropFactory.make_prop(world, "tree_parque", Vector2(tx + 30, 245), Vector2(10, 8))

	PropFactory.make_prop(world, "kiosk_wood", Vector2(490, 115))

	# Luz diurna
	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.99, 0.94)
	stage.add_child(light)

	# Bicicleta de Miguel (controlada pelo jogador)
	player_bike = BikeController.new()
	player_bike.bike_id = "miguel_bike"
	player_bike.is_player = true
	player_bike.position = Vector2(60, 165)
	world.add_child(player_bike)

	# Bicicleta de Maria Fernanda (IA companheira)
	maria_bike = BikeController.new()
	maria_bike.bike_id = "maria_bike"
	maria_bike.is_player = false
	maria_bike.follow_target = player_bike
	maria_bike.follow_offset = Vector2(-28, 14)
	maria_bike.position = Vector2(30, 180)
	world.add_child(maria_bike)

	camera.target = player_bike
	camera.position = Vector2(60, 170)
	camera.set_world_limits(Rect2i(0, 0, 640, 360))

	_create_hint_hud()

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)


func _create_hint_hud() -> void:
	hud_layer = CanvasLayer.new()
	hud_layer.layer = 10
	add_child(hud_layer)

	var p := PanelContainer.new()
	p.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	p.offset_left = 40
	p.offset_right = -40
	p.offset_top = -22
	p.offset_bottom = -6
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.1, 0.12, 0.16, 0.75)
	style.set_corner_radius_all(4)
	p.add_theme_stylebox_override("panel", style)
	hud_layer.add_child(p)

	var lbl := Label.new()
	lbl.text = "[W/A/S/D ou Setas] Guiar Bicicleta | [Espaço] Impulso de Pedalada"
	lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	lbl.add_theme_font_size_override("font_size", 10)
	lbl.add_theme_color_override("font_color", Color("f4ea8a"))
	p.add_child(lbl)


func _process(_delta: float) -> void:
	if transitioning or player_bike == null:
		return

	# Gatilhos de diálogos naturais durante a pedalada
	if not dialogue_shown_1 and player_bike.position.x > 180.0:
		dialogue_shown_1 = true
		runner.say(["c4_s5_dica_pedal"])

	if not dialogue_shown_2 and player_bike.position.x > 330.0:
		dialogue_shown_2 = true
		runner.say(["c4_s5_maria_adorando"])

	# Fim do percurso do passeio (chegada na área aberta da corrida)
	if player_bike.position.x > 530.0:
		transitioning = true
		_start_race_transition()


func _start_race_transition() -> void:
	GameState.controls_locked = true
	player_bike.controls_enabled = false
	maria_bike.controls_enabled = false

	# Maria toca a campainha da bike
	maria_bike.ring_bell()
	await runner.wait(0.5)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

extends Node
## CAPÍTULO FINAL — CENA 02: EXPLOSÃO DE FELICIDADE
## Imediatamente após o sim e o beijo, a tela se enche de partículas comemorativas:
## corações em pixel art, confetes coloridos, estrelas brilhantes e música emocionante.

const NEXT_SCENE := "res://chapters/chapter_final/scene_03_o_primeiro_dia/scene_03.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character
var celebration: CelebrationParticles


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_final"
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

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	# Casal abraçado e se beijando no centro da rua
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(238, 320)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(242, 320)
	world.add_child(maria)

	runner.face(miguel, "right")
	runner.face(maria, "left")

	# Partículas de celebração no centro do casal
	celebration = CelebrationParticles.new()
	celebration.position = Vector2(240, 310)
	stage.add_child(celebration)

	camera.position = Vector2(240, 315)
	camera.zoom = Vector2(1.35, 1.35)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	# Inicia primeira onda de partículas
	celebration.start_burst(1.0)
	await runner.wait(0.8)

	# Câmera se afasta suavemente enquanto a celebração ganha intensidade máxima
	var tw_cam := create_tween()
	tw_cam.tween_property(camera, "zoom", Vector2(1.0, 1.0), 3.5).set_trans(Tween.TRANS_SINE)

	celebration.intensity = 1.8
	AudioManager.play_sfx("sparkle", 2.0)
	await runner.wait(1.5)

	celebration.intensity = 2.4
	await runner.wait(2.0)

	celebration.stop_burst()
	await runner.wait(1.0)

	# O cenário escurece suavemente para a tela preta
	await runner.fade_black(2.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

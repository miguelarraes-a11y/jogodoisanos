extends Node
## CAPÍTULO 2 — CENA 01: O ENCONTRO
## Miguel e Maria Fernanda se encontram na rua do bairro.
## Miguel está com blusa azul; Maria Fernanda com blusa verde e calça branca.

const AFTERNOON_LIGHT := Color(1.0, 0.96, 0.90)
const NEXT_SCENE := "res://chapters/chapter_2/scene_02_caminhada_acai/scene_02.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
	GameState.scene_id = "scene_01"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_first_date", 1.5, -3.0)

	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	var light := CanvasModulate.new()
	light.color = AFTERNOON_LIGHT
	stage.add_child(light)

	# Miguel esperando na calçada
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 300)
	world.add_child(miguel)
	runner.face(miguel, "down")

	# Maria Fernanda se aproximando pela calçada
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(188, 380)
	world.add_child(maria)
	runner.face(maria, "up")

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	# Transição inicial com letreiro delicado
	await runner.fade_black(0.0)
	var title_lbl := Label.new()
	title_lbl.text = "No dia do encontro..."
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_lbl.add_theme_font_size_override("font_size", 14)
	title_lbl.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))
	var overlay := CanvasLayer.new()
	overlay.layer = 20
	overlay.add_child(title_lbl)
	add_child(overlay)

	await runner.wait(2.0)
	overlay.queue_free()

	await runner.fade_from_black(1.2)
	await runner.wait(0.6)

	# Maria Fernanda caminha até o Miguel
	await runner.walk_to(maria, Vector2(188, 322))
	runner.face(maria, "up")
	runner.face(miguel, "down")
	await runner.wait(0.8)

	# Falas naturais e carinhosas
	await runner.say(["c2_s1_miguel_1"])
	await runner.wait(0.4)
	await runner.say(["c2_s1_maria_1"])
	await runner.wait(0.4)
	await runner.say(["c2_s1_miguel_2"])
	await runner.wait(0.6)

	# Ambos viram e começam a caminhar juntos
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.wait(0.3)

	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(188, 250)),
		runner.walk_to.bind(maria, Vector2(202, 252))
	])

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

extends Node
## CAPÍTULO FINAL — CENA 01: O PEDIDO DE NAMORO
## No meio de uma rua tranquila de Petrópolis.
## Miguel para, se ajoelha diante de Maria Fernanda e faz o pedido: "Você quer namorar comigo?"
## Maria aceita com um "Sim!", eles se beijam com emoção.

const NEXT_SCENE := "res://chapters/chapter_final/scene_02_explosao_de_felicidade/scene_02.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character
var kneel_sprite: Sprite2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_final"
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
	AudioManager.play_music("music_closer_to_you", 1.0, -6.0)

	var street := Node2D.new()
	stage.add_child(street)

	world = Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Luz suave de fim de tarde
	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(230, 290)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(250, 290)
	world.add_child(maria)

	camera.target = miguel
	camera.position = Vector2(240, 280)
	camera.zoom = Vector2(1.15, 1.15)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	# Transição inicial com título do Capítulo Final
	await runner.fade_black(0.0)
	var title_lbl := Label.new()
	title_lbl.text = "CAPÍTULO FINAL\nA Melhor Escolha da Minha Vida"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_lbl.add_theme_font_size_override("font_size", 15)
	title_lbl.add_theme_color_override("font_color", Color(0.98, 0.95, 0.90))
	var overlay := CanvasLayer.new()
	overlay.layer = 20
	overlay.add_child(title_lbl)
	add_child(overlay)

	await runner.wait(2.2)
	overlay.queue_free()

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# Caminham juntos descendo a rua tranquila
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(230, 320)),
		runner.walk_to.bind(maria, Vector2(250, 320))
	])
	await runner.wait(0.5)

	await runner.say(["cfinal_s1_caminhada"])
	await runner.wait(0.3)
	await runner.say(["cfinal_s1_maria_concorda"])
	await runner.wait(0.6)

	# Param no meio da rua tranquila
	runner.face(miguel, "right")
	runner.face(maria, "left")
	await runner.wait(0.8)

	# Música ambiente diminui e câmera aproxima
	AudioManager.stop_music(1.2)
	var tw_cam := create_tween()
	tw_cam.tween_property(camera, "zoom", Vector2(1.4, 1.4), 1.5).set_trans(Tween.TRANS_SINE)
	await tw_cam.finished
	await runner.wait(0.6)

	# Miguel se ajoelha diante de Maria Fernanda
	miguel.sprite.visible = false
	kneel_sprite = Sprite2D.new()
	kneel_sprite.texture = load("res://assets/sprites/characters/miguel_kneel.png")
	kneel_sprite.position = miguel.position
	kneel_sprite.centered = true
	world.add_child(kneel_sprite)
	await runner.wait(1.0)

	# O Pedido de Namoro
	await runner.say(["cfinal_s1_pedido_miguel"])
	await runner.wait(0.6)

	# A Resposta de Maria Fernanda: "Sim!"
	await runner.say(["cfinal_s1_resposta_maria"])
	await runner.wait(0.5)

	# Miguel se levanta
	world.remove_child(kneel_sprite)
	kneel_sprite.queue_free()
	kneel_sprite = null
	miguel.sprite.visible = true
	runner.face(miguel, "right")
	await runner.wait(0.3)

	# Os dois se aproximam e se beijam com carinho
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(238, 320)),
		runner.walk_to.bind(maria, Vector2(242, 320))
	])
	runner.face(miguel, "right")
	runner.face(maria, "left")

	# Trilha sonora cresce no beijo e transiciona para a grande explosão de felicidade
	AudioManager.play_music("music_love_theme", 0.5, -2.0)
	await runner.wait(1.2)

	SceneManager.change_scene(NEXT_SCENE, 0.2)

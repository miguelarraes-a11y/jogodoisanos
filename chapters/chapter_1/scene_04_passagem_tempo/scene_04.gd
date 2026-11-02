extends Node
## CAPÍTULO 1 — CENA 04: ALGUNS DIAS DEPOIS. Cutscene de passagem de tempo.
## Transição indicando o avanço de alguns dias.
## Introdução da Casa de Miguel: ambiente acolhedor, sala brasileira,
## presença do Bulldog preto e do Gato cinza.

const NEXT_SCENE := "res://chapters/chapter_1/scene_05_primeira_mensagem/scene_05.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_04"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	# 1) Tela preta com o texto da passagem de tempo
	var overlay := CanvasLayer.new()
	overlay.layer = 15
	add_child(overlay)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(bg)

	var label := Label.new()
	label.text = "Alguns dias depois..."
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	label.set_anchors_preset(Control.PRESET_FULL_RECT)
	label.add_theme_font_size_override("font_size", 12)
	label.add_theme_color_override("font_color", Color("f4ead2"))
	label.modulate.a = 0.0
	overlay.add_child(label)

	# Fade in do texto
	var tw := create_tween()
	tw.tween_property(label, "modulate:a", 1.0, 1.2)
	await tw.finished
	await runner.wait(1.8)

	# Fade out do texto
	tw = create_tween()
	tw.tween_property(label, "modulate:a", 0.0, 0.8)
	await tw.finished

	# 2) Monta o cenário da Casa de Miguel
	living_room = MiguelLivingRoom.new()
	stage.add_child(living_room)
	living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(100, 90)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	# Remove o overlay preto
	overlay.queue_free()

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Câmera faz um suave pan pela sala mostrando os pets e Miguel
	var cam_tween := create_tween()
	cam_tween.tween_property(camera, "position", Vector2(170, 90), 3.0).set_trans(Tween.TRANS_SINE)
	await cam_tween.finished
	await runner.wait(1.2)

	# Transição para a Cena 5
	await runner.fade_black(1.0)
	GameState.scene_id = "scene_05"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.3)

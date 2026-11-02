extends Node
## CAPÍTULO 4 — CENA 08: PASSAGEM DO TEMPO
## Montagem cinematográfica com música acolhedora demonstrando o relacionamento amadurecendo
## e a preparação para conhecer a família um do outro.

const NEXT_SCENE := "res://chapters/chapter_4/scene_09_familia_miguel/scene_09.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	AudioManager.play_music("music_family", 1.5, -3.0)

	await runner.fade_black(0.0)

	var overlay := CanvasLayer.new()
	overlay.layer = 20
	add_child(overlay)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(bg)

	var title_lbl := Label.new()
	title_lbl.text = "Com o passar do tempo..."
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_lbl.position.y = -20
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_lbl.add_theme_color_override("font_color", Color("f4ead2"))
	overlay.add_child(title_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "A cada conversa, o sentimento foi se tornando mais profundo e verdadeiro..."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sub_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	sub_lbl.position.y = 15
	sub_lbl.add_theme_font_size_override("font_size", 12)
	sub_lbl.add_theme_color_override("font_color", Color("d4c6a8"))
	overlay.add_child(sub_lbl)

	await runner.wait(3.2)

	sub_lbl.text = "E então, chegou o momento especial de dar mais um passo..."
	await runner.wait(2.8)

	overlay.queue_free()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

extends Node
## CAPÍTULO FINAL — CENA 03: O PRIMEIRO DIA
## Tela preta cinematográfica com a data inaugural do namoro: 03/11/2024.

const NEXT_SCENE := "res://chapters/chapter_final/scene_04_nossa_historia_e_dois_anos/scene_04.tscn"

var runner: CutsceneRunner


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_final"
	GameState.scene_id = "scene_03"

	runner = CutsceneRunner.new()
	add_child(runner)

	_play()


func _play() -> void:
	await runner.fade_black(0.0)

	var overlay := CanvasLayer.new()
	overlay.layer = 25
	add_child(overlay)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(bg)

	var vbox := VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	overlay.add_child(vbox)

	var date_lbl := Label.new()
	date_lbl.text = "03/11/2024"
	date_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	date_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	date_lbl.add_theme_font_size_override("font_size", 20)
	date_lbl.add_theme_color_override("font_color", Color("ffd166"))
	date_lbl.modulate = Color(1.0, 1.0, 1.0, 0.0)
	vbox.add_child(date_lbl)

	var sub_lbl := Label.new()
	sub_lbl.text = "O primeiro dia da nossa história juntos."
	sub_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	sub_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	sub_lbl.add_theme_font_size_override("font_size", 13)
	sub_lbl.add_theme_color_override("font_color", Color("f4ead2"))
	sub_lbl.modulate = Color(1.0, 1.0, 1.0, 0.0)
	vbox.add_child(sub_lbl)

	# Fade in dos textos
	var tw_in := create_tween().set_parallel(true)
	tw_in.tween_property(date_lbl, "modulate:a", 1.0, 1.5)
	tw_in.tween_property(sub_lbl, "modulate:a", 1.0, 1.8)
	await tw_in.finished

	# Permanece visível por alguns segundos
	await runner.wait(3.5)

	# Fade out suave
	var tw_out := create_tween().set_parallel(true)
	tw_out.tween_property(date_lbl, "modulate:a", 0.0, 1.2)
	tw_out.tween_property(sub_lbl, "modulate:a", 0.0, 1.2)
	await tw_out.finished

	overlay.queue_free()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

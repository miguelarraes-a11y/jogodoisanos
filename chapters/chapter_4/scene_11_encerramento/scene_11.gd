extends Node
## CAPÍTULO 4 — CENA 11: ENCERRAMENTO DO CAPÍTULO
## Miguel e Maria Fernanda juntos após conhecerem as famílias.
## Câmera se afasta lentamente, tela final: FIM DO CAPÍTULO 4 — PEDALANDO JUNTOS (CONTINUA...).

const REPLAY_SCENE := "res://chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn"
const NEXT_CHAPTER := "res://chapters/chapter_final/scene_01_o_pedido_de_namoro/scene_01.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var end_layer: CanvasLayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
	GameState.scene_id = "scene_11"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_family", 1.0, -3.0)

	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Luz serena do início de noite
	var light := CanvasModulate.new()
	light.color = Color(0.60, 0.60, 0.78)
	stage.add_child(light)

	var miguel := Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(182, 230)
	world.add_child(miguel)

	var maria := Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(196, 230)
	world.add_child(maria)

	runner.face(miguel, "right")
	runner.face(maria, "left")

	camera.target = miguel
	camera.position = Vector2(189, 230)
	camera.zoom = Vector2(1.2, 1.2)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	await runner.say(["c4_s11_momento_juntos"])
	await runner.wait(0.4)
	await runner.say(["c4_s11_maria_sorriso"])
	await runner.wait(0.6)

	# Câmera se afasta lentamente mostrando a rua tranquila
	var tw := create_tween()
	tw.tween_property(camera, "zoom", Vector2(1.0, 1.0), 3.5).set_trans(Tween.TRANS_SINE)

	await runner.say(["c4_s11_fim_texto"])
	await runner.wait(2.0)

	# Salva o progresso concluído do Capítulo 4
	GameState.set_flag("chapter_4_completed", true)
	GameState.scene_id = "chapter_4_end"
	GameState.save_game()

	# Tela final do Capítulo 4
	await runner.fade_black(2.0)
	_show_end_screen()


func _show_end_screen() -> void:
	end_layer = CanvasLayer.new()
	end_layer.layer = 15
	add_child(end_layer)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	end_layer.add_child(bg)

	var poem := Label.new()
	poem.text = "E assim, pedalada a pedalada,\ncada momento fortalecia o que estava destinado a ser eterno..."
	poem.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	poem.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	poem.set_anchors_preset(Control.PRESET_FULL_RECT)
	poem.position.y = -35
	poem.add_theme_font_size_override("font_size", 13)
	poem.add_theme_color_override("font_color", Color("d4c6a8"))
	end_layer.add_child(poem)

	var title := Label.new()
	title.text = "FIM DO CAPÍTULO 4\nPEDALANDO JUNTOS"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_FULL_RECT)
	title.position.y = 10
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("f4ead2"))
	end_layer.add_child(title)

	var next_lbl := Label.new()
	next_lbl.text = "CAPÍTULO FINAL DISPONÍVEL"
	next_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	next_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	next_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	next_lbl.position.y = 48
	next_lbl.add_theme_font_size_override("font_size", 13)
	next_lbl.add_theme_color_override("font_color", Color("ffd166"))
	end_layer.add_child(next_lbl)

	var hint := Label.new()
	hint.text = "[Enter / Espaço] Iniciar Capítulo Final | [R] Rever Cap. 4 | [1 a 0] Cenas"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hint.position.y = -22
	hint.add_theme_font_size_override("font_size", 11)
	hint.add_theme_color_override("font_color", Color("8a7b68"))
	end_layer.add_child(hint)


func _unhandled_input(event: InputEvent) -> void:
	if end_layer == null:
		return
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		AudioManager.stop_music(0.8)
		SceneManager.change_scene(NEXT_CHAPTER, 0.5)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				AudioManager.stop_music(0.8)
				SceneManager.change_scene(REPLAY_SCENE, 0.4)
			KEY_1:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_02_o_reencontro_e_beijo/scene_02.tscn", 0.3)
			KEY_3:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_03_viagem_onibus/scene_03.tscn", 0.3)
			KEY_4:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_04_chegada_parque/scene_04.tscn", 0.3)
			KEY_5:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_05_passeio_bicicleta/scene_05.tscn", 0.3)
			KEY_6:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_06_corrida_bicicleta/scene_06.tscn", 0.3)
			KEY_7:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_07_voltando_para_casa/scene_07.tscn", 0.3)
			KEY_8:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_08_passagem_tempo/scene_08.tscn", 0.3)
			KEY_9:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_09_familia_miguel/scene_09.tscn", 0.3)
			KEY_0:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_4/scene_10_familia_maria/scene_10.tscn", 0.3)

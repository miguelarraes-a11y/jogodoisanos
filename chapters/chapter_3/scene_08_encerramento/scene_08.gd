extends Node
## CAPÍTULO 3 — CENA 08: ENCERRAMENTO DO CAPÍTULO
## Miguel volta para casa com um sorriso sereno.
## Tela final: FIM DO CAPÍTULO 3 — MAIS PERTO DE VOCÊ (CONTINUA...).

const REPLAY_SCENE := "res://chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn"
const NEXT_CHAPTER := "res://chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var end_layer: CanvasLayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
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
	AudioManager.play_music("music_closer_to_you", 1.0, -4.0)

	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	var light := CanvasModulate.new()
	light.color = Color(0.55, 0.55, 0.75)
	stage.add_child(light)

	var miguel := Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 180)
	world.add_child(miguel)
	runner.face(miguel, "down")

	camera.target = miguel
	camera.position = Vector2(188, 180)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.4)

	# Miguel desce a calçada com passos calmos e sorriso leve
	await runner.walk_to(miguel, Vector2(188, 260))
	await runner.wait(0.5)

	# Pensamento sereno de Miguel
	await runner.say(["c3_s8_miguel_feliz"])
	await runner.wait(0.6)

	await runner.walk_to(miguel, Vector2(188, 320))
	await runner.say(["c3_s8_fim_texto"])
	await runner.wait(1.0)

	# Salva o progresso concluído do Capítulo 3
	GameState.set_flag("chapter_3_completed", true)
	GameState.scene_id = "chapter_3_end"
	GameState.save_game()

	# Tela final do Capítulo 3
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
	poem.text = "E a cada novo encontro,\num sentimento que não para de crescer..."
	poem.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	poem.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	poem.set_anchors_preset(Control.PRESET_FULL_RECT)
	poem.position.y = -35
	poem.add_theme_font_size_override("font_size", 13)
	poem.add_theme_color_override("font_color", Color("d4c6a8"))
	end_layer.add_child(poem)

	var title := Label.new()
	title.text = "FIM DO CAPÍTULO 3\nMAIS PERTO DE VOCÊ"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_FULL_RECT)
	title.position.y = 10
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("f4ead2"))
	end_layer.add_child(title)

	var next_lbl := Label.new()
	next_lbl.text = "CONTINUA..."
	next_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	next_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	next_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	next_lbl.position.y = 48
	next_lbl.add_theme_font_size_override("font_size", 14)
	next_lbl.add_theme_color_override("font_color", Color("a8dfc8"))
	end_layer.add_child(next_lbl)

	var hint := Label.new()
	hint.text = "[Enter / Espaço] Iniciar Capítulo 4 — Pedalando Juntos\n[1 a 7] Cenas Cap. 3 | [C2] Cap. 2 | [C1] Cap. 1 | [P] Prólogo"
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
		SceneManager.change_scene(NEXT_CHAPTER, 0.4)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_1:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_02_o_novo_encontro/scene_02.tscn", 0.3)
			KEY_3:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_03_banco_de_pedra/scene_03.tscn", 0.3)
			KEY_4:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_04_tirando_fotos/scene_04.tscn", 0.3)
			KEY_5:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_05_o_beijo/scene_05.tscn", 0.3)
			KEY_6:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_06_caminhada_avo/scene_06.tscn", 0.3)
			KEY_7:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_3/scene_07_despedida_avo/scene_07.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_01_encontro/scene_01.tscn", 0.3)
			KEY_P:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn", 0.3)

extends Node
## CENA 05 — O PRIMEIRO OLHAR. Cutscene cinematográfica.
## 1) Miguel olha em direção à prima.
## 2) A câmera revela a calçada: a prima e Maria Fernanda aparecem.
## 3) Primeiro contato visual entre Miguel e Maria Fernanda.
## 4) Som ambiente diminui, música delicada e nostálgica começa.
## 5) Câmera alterna discretamente entre os dois olhares.
## 6) Tela escurece: FIM DO PRÓLOGO.

const SUNSET := Color(1.0, 0.88, 0.74)
const CHAPTER_1_SCENE := "res://chapters/chapter_1/scene_01_depois_do_olhar/scene_01.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var prima: Character
var maria: Character

var end_layer: CanvasLayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "prologue"
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
	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	var sunset_mod := CanvasModulate.new()
	sunset_mod.color = SUNSET
	stage.add_child(sunset_mod)

	# Miguel no asfalto, olhando para cima/calçada
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = Vector2(235, 330)
	world.add_child(miguel)
	runner.face(miguel, "up")

	# Prima na calçada da esquerda, próxima ao portão
	prima = Character.new()
	prima.character_id = "prima"
	prima.position = Vector2(184, 260)
	world.add_child(prima)
	runner.face(prima, "down")

	# Maria Fernanda na calçada, chegando com seu saquinho de doces
	maria = Character.new()
	maria.character_id = "maria_fernanda"
	maria.position = Vector2(174, 240)
	world.add_child(maria)
	runner.face(maria, "down")

	# Câmera começa enquadrando Miguel
	camera.set_world_limits(StreetBuilder.WORLD)
	camera.position = miguel.position - Vector2(0, 30)

	var ambient := AudioManager.play_sfx("ambient_street", -12.0, true)
	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# 1-3) Miguel olha em direção à voz da prima. A câmera sobe revelando a calçada
	await runner.move_camera(camera, Vector2(195, 270), 2.2)
	await runner.wait(0.4)

	# Diálogo da Prima e de Miguel (apenas os dois conversam)
	await runner.say(["s5_prima_pergunta"])
	await runner.say(["s5_miguel_responde"])
	await runner.say(["s5_prima_fala"])

	# 4) Maria Fernanda dá um passo à frente na calçada segurando seu saquinho de doces
	await runner.walk_to(maria, Vector2(184, 250))
	runner.face(maria, "down")
	await runner.wait(0.6)

	# 5-8) Primeiro contato visual silencioso entre Miguel e Maria Fernanda
	# Diminui suavemente o som ambiente da rua
	if ambient != null and is_instance_valid(ambient):
		AudioManager.stop_player(ambient, 2.0)

	# Inicia a trilha instrumental delicada e marcante
	AudioManager.play_music("music_first_look", 1.8, -7.0)
	await runner.wait(1.0)

	# 11) Enquadramentos calmos alternando entre Miguel e Maria Fernanda em silêncio
	# Focaliza Miguel
	await runner.move_camera(camera, Vector2(235, 320), 1.6)
	await runner.wait(2.2)

	# Focaliza Maria Fernanda
	await runner.move_camera(camera, Vector2(184, 250), 1.6)
	await runner.wait(2.4)

	# Enquadra os dois juntos no cenário
	await runner.move_camera(camera, Vector2(210, 285), 2.0)
	await runner.wait(3.5)

	# 13-14) A imagem escurece gradualmente para preto
	await runner.fade_black(2.5)
	await runner.wait(0.5)

	# Salva o progresso concluído do Prólogo
	GameState.set_flag("prologue_completed", true)
	GameState.scene_id = "prologue_end"
	GameState.save_game()

	# Tela final do Prólogo
	_show_end_screen()


func _show_end_screen() -> void:
	end_layer = CanvasLayer.new()
	end_layer.layer = 10
	add_child(end_layer)

	var bg := ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	end_layer.add_child(bg)

	var title := Label.new()
	title.text = "FIM DO PRÓLOGO"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_FULL_RECT)
	title.position.y = -22
	title.add_theme_font_size_override("font_size", 14)
	title.add_theme_color_override("font_color", Color("f4ead2"))
	end_layer.add_child(title)

	var subtitle := Label.new()
	subtitle.text = "27 de setembro de 2024\n\nOnde tudo começou..."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle.set_anchors_preset(Control.PRESET_FULL_RECT)
	subtitle.position.y = 8
	subtitle.add_theme_font_size_override("font_size", 9)
	subtitle.add_theme_color_override("font_color", Color("d4c6a8"))
	end_layer.add_child(subtitle)

	var hint := Label.new()
	hint.text = "[Enter / Espaço] Iniciar Capítulo 1 — A Primeira Mensagem\n[1 a 5] Rever cena do Prólogo | [R] Rever Prólogo completo"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hint.position.y = -30
	hint.add_theme_font_size_override("font_size", 7)
	hint.add_theme_color_override("font_color", Color("8a7b68"))
	end_layer.add_child(hint)


func _unhandled_input(event: InputEvent) -> void:
	if end_layer == null:
		return
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		AudioManager.stop_music(1.0)
		SceneManager.change_scene(CHAPTER_1_SCENE, 0.5)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn", 0.3)
			KEY_1:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_02_manha_miguel/scene_02.tscn", 0.3)
			KEY_3:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_03_tarde_maria/scene_03.tscn", 0.3)
			KEY_4:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_04_abacate/scene_04.tscn", 0.3)
			KEY_5:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_05_primeiro_olhar/scene_05.tscn", 0.3)

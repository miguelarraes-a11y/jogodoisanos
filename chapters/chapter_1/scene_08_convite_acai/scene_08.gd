extends Node
## CAPÍTULO 1 — CENA 08: O CONVITE DO AÇAÍ. Cutscene climática.
## Miguel decide convidar Maria Fernanda para tomar um açaí.
## Ela responde confirmando com alegria ("Quero sim!").
## Toca a trilha alegre e nostálgica.
## Encerramento do Capítulo 1 com opções de rever cenas.

const REPLAY_SCENE := "res://chapters/chapter_1/scene_01_depois_do_olhar/scene_01.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom
var phone: PhoneOverlay
var chat: WhatsAppApp
var end_layer: CanvasLayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
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
	living_room = MiguelLivingRoom.new()
	stage.add_child(living_room)
	var miguel := living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(170, 95)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	# Luz aconchegante de fim de tarde
	living_room.light.color = Color(1.0, 0.90, 0.78)

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# Pensamento de Miguel
	await runner.say(["c1_s8_miguel_pensamento"])
	await runner.wait(0.5)

	# Miguel pega o celular e abre o WhatsApp
	phone = PhoneOverlay.new()
	add_child(phone)

	chat = WhatsAppApp.new()
	await phone.open(chat)
	await runner.wait(0.8)

	# Miguel envia a mensagem do convite
	var invite_text: String = Dialogues.get_line("c1_s8_miguel_mensagem").get("text", "Quer ir tomar um açaí comigo?")
	await chat.add_message(invite_text, false, "18:15")
	await runner.wait(1.2)

	# Maria fica online e depois digitando...
	chat.set_typing(true)
	await runner.wait(2.2)
	chat.set_typing(false)

	# Resposta afirmativa de Maria
	var reply_text: String = Dialogues.get_line("c1_s8_maria_resposta").get("text", "Quero sim!")
	await chat.add_message(reply_text, true, "18:16")

	# Toca a música alegre e nostálgica!
	AudioManager.play_music("music_joyful", 1.0, -4.0)
	await runner.wait(1.0)

	# Reação feliz de Miguel
	await runner.say(["c1_s8_miguel_reacao"])
	await runner.wait(0.6)

	# Pets reagem felizes: bulldog vira a cabeça
	runner.face(living_room.bulldog, "left")
	await runner.wait(0.5)

	# Celular fecha
	await phone.close()
	await runner.wait(1.0)

	# Câmera afasta lentamente
	var t := create_tween()
	t.tween_property(camera, "zoom", Vector2(1.0, 1.0), 2.5).set_trans(Tween.TRANS_SINE)
	await t.finished
	await runner.wait(1.0)

	# Fade suave para preto
	await runner.fade_black(2.0)
	await runner.wait(0.6)

	# Salva o progresso concluído do Capítulo 1
	GameState.set_flag("chapter_1_completed", true)
	GameState.scene_id = "chapter_1_end"
	GameState.save_game()

	# Tela final do Capítulo 1
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
	poem.text = "E assim, a primeira mensagem abriu as portas\npara o primeiro encontro..."
	poem.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	poem.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	poem.set_anchors_preset(Control.PRESET_FULL_RECT)
	poem.position.y = -35
	poem.add_theme_font_size_override("font_size", 9)
	poem.add_theme_color_override("font_color", Color("d4c6a8"))
	end_layer.add_child(poem)

	var title := Label.new()
	title.text = "FIM DO CAPÍTULO 1\nA PRIMEIRA MENSAGEM"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title.set_anchors_preset(Control.PRESET_FULL_RECT)
	title.position.y = 5
	title.add_theme_font_size_override("font_size", 12)
	title.add_theme_color_override("font_color", Color("f4ead2"))
	end_layer.add_child(title)

	var next_lbl := Label.new()
	next_lbl.text = "CONTINUA..."
	next_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	next_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	next_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	next_lbl.position.y = 35
	next_lbl.add_theme_font_size_override("font_size", 10)
	next_lbl.add_theme_color_override("font_color", Color("a8dfc8"))
	end_layer.add_child(next_lbl)

	var hint := Label.new()
	hint.text = "[Enter / Espaço] Iniciar Capítulo 2 — O Primeiro Encontro\n[R] Rever Capítulo 1 | [1 a 8] Cenas Cap. 1 | [P] Prólogo"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	hint.position.y = -22
	hint.add_theme_font_size_override("font_size", 10)
	hint.add_theme_color_override("font_color", Color("8a7b68"))
	end_layer.add_child(hint)


func _unhandled_input(event: InputEvent) -> void:
	if end_layer == null:
		return
	if event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		AudioManager.stop_music(0.8)
		SceneManager.change_scene("res://chapters/chapter_2/scene_01_encontro/scene_01.tscn", 0.4)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				AudioManager.stop_music(0.8)
				SceneManager.change_scene(REPLAY_SCENE, 0.4)
			KEY_1:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_01_depois_do_olhar/scene_01.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_02_instagram_solicitacao/scene_02.tscn", 0.3)
			KEY_3:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_03_festa_amigo/scene_03.tscn", 0.3)
			KEY_4:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_04_passagem_tempo/scene_04.tscn", 0.3)
			KEY_5:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_05_primeira_mensagem/scene_05.tscn", 0.3)
			KEY_6:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_06_uno/scene_06.tscn", 0.3)
			KEY_7:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_07_conversas_continuam/scene_07.tscn", 0.3)
			KEY_8:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_1/scene_08_convite_acai/scene_08.tscn", 0.3)
			KEY_P:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn", 0.3)

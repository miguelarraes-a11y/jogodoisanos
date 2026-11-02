extends Node
## CAPÍTULO 1 — CENA 05: A PRIMEIRA MENSAGEM. Cutscene + Gameplay Interativo.
## Miguel está na sala de casa quando recebe uma notificação no WhatsApp.
## O celular abre e a conversa com Maria Fernanda se inicia.
## O jogador escolhe respostas interativas e a conversa flui com naturalidade e nostalgia.

const NEXT_SCENE := "res://chapters/chapter_1/scene_06_uno/scene_06.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom
var phone: PhoneOverlay
var chat: WhatsAppApp


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
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
	living_room = MiguelLivingRoom.new()
	stage.add_child(living_room)
	living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(170, 95)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(0.8)
	await runner.wait(0.8)

	# Toca som de notificação
	AudioManager.play_sfx("phone_notification", -3.0)

	# Mostra notificação estilizada no topo da tela com atalho de clique ou tecla
	var notif_layer := CanvasLayer.new()
	notif_layer.layer = 14
	add_child(notif_layer)

	var notif_banner := Panel.new()
	notif_banner.position = Vector2(40, -30)
	notif_banner.size = Vector2(240, 24)
	var st := StyleBoxFlat.new()
	st.bg_color = Color("075e54")
	st.border_color = Color("25d366")
	st.set_border_width_all(1)
	st.set_corner_radius_all(4)
	notif_banner.add_theme_stylebox_override("panel", st)
	notif_layer.add_child(notif_banner)

	var notif_lbl := Label.new()
	notif_lbl.text = "💬 WhatsApp: Nova mensagem de Maria Fernanda"
	notif_lbl.position = Vector2(6, 2)
	notif_lbl.add_theme_font_size_override("font_size", 7)
	notif_lbl.add_theme_color_override("font_color", Color.WHITE)
	notif_banner.add_child(notif_lbl)

	var hint_lbl := Label.new()
	hint_lbl.text = "Abrindo conversa..."
	hint_lbl.position = Vector2(6, 12)
	hint_lbl.add_theme_font_size_override("font_size", 5)
	hint_lbl.add_theme_color_override("font_color", Color("a8dfc8"))
	notif_banner.add_child(hint_lbl)

	# Animação de descida do banner
	var t_banner := create_tween()
	t_banner.tween_property(notif_banner, "position:y", 6.0, 0.35).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await t_banner.finished

	await runner.wait(1.4)

	# Some o banner de notificação
	var t_banner_out := create_tween()
	t_banner_out.tween_property(notif_banner, "position:y", -30.0, 0.25)
	await t_banner_out.finished
	notif_layer.queue_free()

	# Abre o celular com o WhatsApp
	phone = PhoneOverlay.new()
	add_child(phone)

	chat = WhatsAppApp.new()
	await phone.open(chat)
	await runner.wait(0.6)

	# Maria começa digitando
	chat.set_typing(true)
	await runner.wait(1.8)
	chat.set_typing(false)

	# Primeira mensagem de Maria
	var line1: Dictionary = Dialogues.get_line("c1_s5_msg_maria_1")
	await chat.add_message(line1.get("text", "Oi, Miguel! Tudo bem? Minha prima me passou seu número."), true, "17:42")
	await runner.wait(0.6)

	# Jogador escolhe resposta 1
	var opt1a: String = Dialogues.get_line("c1_s5_opt_1a").get("text", "Oi, Maria Fernanda! Tudo bem e com você? Que bom que você chamou!")
	var opt1b: String = Dialogues.get_line("c1_s5_opt_1b").get("text", "Oi! Tudo bem sim! Lembro de ter te visto naquele dia do Cosme e Damião.")
	var choice1: String = await chat.prompt_choice([opt1a, opt1b])

	await chat.add_message(choice1, false, "17:43")
	await runner.wait(1.0)

	# Maria digita segunda mensagem
	chat.set_typing(true)
	await runner.wait(2.0)
	chat.set_typing(false)

	var line2: Dictionary = Dialogues.get_line("c1_s5_msg_maria_2")
	await chat.add_message(line2.get("text", "Eu te vi chutando aquele abacate na rua haha! Achei engraçado."), true, "17:44")
	await runner.wait(0.6)

	# Jogador escolhe resposta 2
	var opt2a: String = Dialogues.get_line("c1_s5_opt_2a").get("text", "Pois é, eu tava tentando abrir no chute mas não deu muito certo haha!")
	var opt2b: String = Dialogues.get_line("c1_s5_opt_2b").get("text", "Tava distraído na descida pra casa, nem percebi vocês chegando!")
	var choice2: String = await chat.prompt_choice([opt2a, opt2b])

	await chat.add_message(choice2, false, "17:44")
	await runner.wait(1.0)

	# Maria digita terceira mensagem
	chat.set_typing(true)
	await runner.wait(1.5)
	chat.set_typing(false)

	var line3: Dictionary = Dialogues.get_line("c1_s5_msg_maria_3")
	await chat.add_message(line3.get("text", "A gente conseguiu pegar bastante doce naquele dia!"), true, "17:45")
	await runner.wait(1.4)

	# Fecha o celular suavemente
	await phone.close()
	await runner.wait(0.6)

	# Avança para a Cena 06
	await runner.fade_black(0.8)
	GameState.scene_id = "scene_06"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.3)

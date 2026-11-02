extends Node
## CAPÍTULO 2 — CENA 11: A MENSAGEM DE AGRADECIMENTO & FIM DO CAPÍTULO 2
## Maria Fernanda manda a mensagem: "Obrigada pelo dia, eu gostei muito."
## Miguel recebe no celular, abre com um sorriso no rosto.
## Encerramento oficial do Capítulo 2 — O Primeiro Encontro.

const REPLAY_SCENE := "res://chapters/chapter_2/scene_01_encontro/scene_01.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom
var phone: PhoneOverlay
var chat: WhatsAppApp
var end_layer: CanvasLayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
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
	living_room = MiguelLivingRoom.new()
	stage.add_child(living_room)
	var miguel := living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(170, 95)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	# Luz suave e tranquila da noite
	if living_room.light:
		living_room.light.color = Color(0.85, 0.85, 0.95)

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# Notificação de mensagem no celular
	AudioManager.play_sfx("phone_notification", -2.0)

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
	notif_lbl.position = Vector2(6, 4)
	notif_lbl.add_theme_font_size_override("font_size", 12)
	notif_lbl.add_theme_color_override("font_color", Color.WHITE)
	notif_banner.add_child(notif_lbl)

	# Animação de descida do banner
	var tw := create_tween()
	tw.tween_property(notif_banner, "position:y", 8.0, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await tw.finished
	await runner.wait(1.0)

	# Miguel abre o celular
	phone = PhoneOverlay.new()
	add_child(phone)

	chat = WhatsAppApp.new()
	await phone.open(chat)
	notif_layer.queue_free()

	await runner.wait(0.8)

	# Maria digitando...
	chat.set_typing(true)
	await runner.wait(2.0)
	chat.set_typing(false)

	# Mensagem oficial real e definitiva: "Obrigada pelo dia, eu gostei muito."
	var msg_text: String = Dialogues.get_line("c2_s11_msg_maria").get("text", "Obrigada pelo dia, eu gostei muito.")
	await chat.add_message(msg_text, true, "20:42")
	await runner.wait(1.5)

	# Miguel responde com carinho
	await chat.add_message("Eu também amei cada minuto! Descansa bem :)", false, "20:43")
	await runner.wait(1.8)

	# Pensamento de Miguel
	await runner.say(["c2_s11_miguel_pensamento"])
	await runner.wait(0.8)

	# Fecha o celular
	await phone.close()
	await runner.wait(1.0)

	# Narração final
	await runner.say(["c2_s11_fim"])
	await runner.wait(1.0)

	# Câmera afasta suavemente
	var t := create_tween()
	t.tween_property(camera, "zoom", Vector2(1.0, 1.0), 2.5).set_trans(Tween.TRANS_SINE)
	await t.finished
	await runner.wait(1.0)

	# Salva o progresso concluído do Capítulo 2
	GameState.set_flag("chapter_2_completed", true)
	GameState.scene_id = "chapter_2_end"
	GameState.save_game()

	# Tela final do Capítulo 2
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
	poem.text = "E assim terminou o primeiro encontro...\nUm açaí, uma cesta de basquete e um beijo inesquecível."
	poem.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	poem.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	poem.set_anchors_preset(Control.PRESET_FULL_RECT)
	poem.position.y = -35
	poem.add_theme_font_size_override("font_size", 13)
	poem.add_theme_color_override("font_color", Color("d4c6a8"))
	end_layer.add_child(poem)

	var title := Label.new()
	title.text = "FIM DO CAPÍTULO 2\nO PRIMEIRO ENCONTRO"
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
	hint.text = "[Enter / Espaço] Iniciar Capítulo 3 — Mais Perto de Você\n[R] Rever Cap. 2 | [1 a 9] Cenas Cap. 2 | [P] Prólogo"
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
		SceneManager.change_scene("res://chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn", 0.4)
	elif event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_R:
				AudioManager.stop_music(0.8)
				SceneManager.change_scene(REPLAY_SCENE, 0.4)
			KEY_1:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_01_encontro/scene_01.tscn", 0.3)
			KEY_2:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_02_caminhada_acai/scene_02.tscn", 0.3)
			KEY_3:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_03_acaiteria/scene_03.tscn", 0.3)
			KEY_4:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_04_conversa_acai/scene_04.tscn", 0.3)
			KEY_5:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_05_decisao_quadra/scene_05.tscn", 0.3)
			KEY_6:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_06_caminhada_quadra/scene_06.tscn", 0.3)
			KEY_7:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_07_aula_basquete/scene_07.tscn", 0.3)
			KEY_8:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_08_caminhada_avo/scene_08.tscn", 0.3)
			KEY_9:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/chapter_2/scene_09_despedida/scene_09.tscn", 0.3)
			KEY_P:
				AudioManager.stop_music(0.5)
				SceneManager.change_scene("res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn", 0.3)

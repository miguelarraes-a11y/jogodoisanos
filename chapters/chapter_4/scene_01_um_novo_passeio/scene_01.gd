extends Node
## CAPÍTULO 4 — CENA 01: UM NOVO PASSEIO
## Miguel em casa recebe mensagem de Maria Fernanda.
## Os dois combinam de ir de ônibus até o Parque de Exposições em Itaipava para andar de bicicleta.

const NEXT_SCENE := "res://chapters/chapter_4/scene_02_o_reencontro_e_beijo/scene_02.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom
var phone: PhoneOverlay
var chat: WhatsAppApp


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	living_room = MiguelLivingRoom.new()
	stage.add_child(living_room)
	living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(170, 95)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	# Transição inicial com título do capítulo
	await runner.fade_black(0.0)
	var title_lbl := Label.new()
	title_lbl.text = "CAPÍTULO 4\nPedalando Juntos"
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_lbl.add_theme_font_size_override("font_size", 15)
	title_lbl.add_theme_color_override("font_color", Color(0.95, 0.95, 0.98))
	var overlay := CanvasLayer.new()
	overlay.layer = 20
	overlay.add_child(title_lbl)
	add_child(overlay)

	await runner.wait(2.0)
	overlay.queue_free()

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# Notificação de mensagem
	AudioManager.play_sfx("phone_notification")
	await runner.wait(0.6)

	# Abre o celular com WhatsApp
	phone = PhoneOverlay.new()
	add_child(phone)

	chat = WhatsAppApp.new()
	await phone.open(chat)
	await runner.wait(0.6)

	# Conversa combinando o passeio
	var msg1: String = Dialogues.get_line("c4_s1_miguel_msg1").get("text", "Oi! O que acha da gente fazer um passeio diferente hoje à tarde?")
	await chat.add_message(msg1, false, "14:20")
	await runner.wait(1.4)

	chat.set_typing(true)
	await runner.wait(1.8)
	chat.set_typing(false)
	var resp1: String = Dialogues.get_line("c4_s1_maria_msg1").get("text", "Oi, Miguel! Adorei a ideia! Tava querendo muito sair. Pra onde a gente vai?")
	await chat.add_message(resp1, true, "14:21")
	await runner.wait(1.4)

	var msg2: String = Dialogues.get_line("c4_s1_miguel_msg2").get("text", "Pensei na gente pegar o ônibus e ir até o Parque de Exposições em Itaipava pra andar de bicicleta!")
	await chat.add_message(msg2, false, "14:22")
	await runner.wait(1.6)

	chat.set_typing(true)
	await runner.wait(2.0)
	chat.set_typing(false)
	var resp2: String = Dialogues.get_line("c4_s1_maria_msg2").get("text", "Nossa, perfeito! Eu amo andar de bicicleta. Te encontro no ponto daqui a pouco!")
	await chat.add_message(resp2, true, "14:23")
	await runner.wait(2.0)

	await phone.close()
	await runner.wait(0.6)

	# Transição: "No dia do passeio..."
	await runner.fade_black(1.2)
	var day_lbl := Label.new()
	day_lbl.text = "Mais tarde, no ponto de ônibus..."
	day_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	day_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	day_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	day_lbl.add_theme_font_size_override("font_size", 13)
	day_lbl.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))

	var overlay2 := CanvasLayer.new()
	overlay2.layer = 20
	overlay2.add_child(day_lbl)
	add_child(overlay2)

	await runner.wait(2.0)
	overlay2.queue_free()

	SceneManager.change_scene(NEXT_SCENE, 0.4)

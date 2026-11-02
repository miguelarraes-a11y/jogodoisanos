extends Node
## CAPÍTULO 3 — CENA 01: MARCANDO DE SE ENCONTRAR
## Algum tempo depois do primeiro encontro...
## Miguel e Maria combinam um novo encontro pelo WhatsApp.

const NEXT_SCENE := "res://chapters/chapter_3/scene_02_o_novo_encontro/scene_02.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom
var phone: PhoneOverlay
var chat: WhatsAppApp


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
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

	# Transição inicial com letreiro delicado
	await runner.fade_black(0.0)
	var title_lbl := Label.new()
	title_lbl.text = "Algum tempo depois..."
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	title_lbl.add_theme_font_size_override("font_size", 14)
	title_lbl.add_theme_color_override("font_color", Color(0.9, 0.9, 0.95))
	var overlay := CanvasLayer.new()
	overlay.layer = 20
	overlay.add_child(title_lbl)
	add_child(overlay)

	await runner.wait(2.0)
	overlay.queue_free()

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# Abre o WhatsApp
	phone = PhoneOverlay.new()
	add_child(phone)

	chat = WhatsAppApp.new()
	await phone.open(chat)
	await runner.wait(0.6)

	# Mensagem de Miguel convidando
	var msg1: String = Dialogues.get_line("c3_s1_miguel_msg1").get("text", "Oi! Tava pensando... você tá livre hoje à tarde?")
	await chat.add_message(msg1, false, "15:10")
	await runner.wait(1.2)

	# Maria responde
	chat.set_typing(true)
	await runner.wait(1.8)
	chat.set_typing(false)
	var resp1: String = Dialogues.get_line("c3_s1_maria_msg1").get("text", "Oi, Miguel! Tô sim, acabei de terminar as coisas da escola.")
	await chat.add_message(resp1, true, "15:11")
	await runner.wait(1.0)

	# Miguel propõe o banco de pedra
	var msg2: String = Dialogues.get_line("c3_s1_miguel_msg2").get("text", "Bora se ver? Tem um lugar bem tranquilo perto da praça, com um banco de pedra na sombra.")
	await chat.add_message(msg2, false, "15:12")
	await runner.wait(1.2)

	# Maria aceita
	chat.set_typing(true)
	await runner.wait(1.6)
	chat.set_typing(false)
	var resp2: String = Dialogues.get_line("c3_s1_maria_msg2").get("text", "Adorei a ideia! Te encontro lá daqui a pouquinho :)")
	await chat.add_message(resp2, true, "15:13")
	await runner.wait(1.5)

	# Fecha celular
	await phone.close()
	await runner.wait(0.8)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

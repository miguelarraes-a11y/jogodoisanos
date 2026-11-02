extends Node
## CAPÍTULO 1 — CENA 03: A FESTA DO AMIGO. Cutscene + Interação.
## Miguel está na festa de um amigo (confraternização residencial brasileira).
## Ele confere o celular e encontra a solicitação de Maria Fernanda.
## O jogador aceita a solicitação e a festa continua normalmente.

const WARM_EVENING := Color(1.0, 0.85, 0.70)
const NEXT_SCENE := "res://chapters/chapter_1/scene_04_passagem_tempo/scene_04.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var amigo: Character
var amigo2: Character
var phone: PhoneOverlay
var ambient_player: AudioStreamPlayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_03"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	# Som ambiente suave de confraternização
	ambient_player = AudioManager.play_sfx("party_ambient", -6.0, true)

	var yard := Node2D.new()
	stage.add_child(yard)

	# Piso do quintal / varanda
	PropFactory.make_ground(yard, "floor_ceramic", Rect2(0, 0, 320, 180), -2)

	var world := Node2D.new()
	world.y_sort_enabled = true
	yard.add_child(world)

	# Paredes de fundo da casa do amigo
	PropFactory.make_ground(yard, "wall_miguel", Rect2(0, 0, 320, 48), -1)

	# Elementos do quintal / churrasco
	PropFactory.make_prop(world, "tree", Vector2(35, 75))
	PropFactory.make_prop(world, "barbecue_grill", Vector2(250, 75), Vector2(24, 20))
	PropFactory.make_prop(world, "party_table", Vector2(160, 95), Vector2(40, 20))
	PropFactory.make_prop(world, "party_chair", Vector2(135, 95), Vector2(12, 12))
	PropFactory.make_prop(world, "party_chair", Vector2(185, 95), Vector2(12, 12))

	# Luz aconchegante de início de noite
	var light := CanvasModulate.new()
	light.color = WARM_EVENING
	stage.add_child(light)

	# Personagens
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = Vector2(120, 120)
	world.add_child(miguel)
	runner.face(miguel, "right")

	amigo = Character.new()
	amigo.character_id = "morador"
	amigo.position = Vector2(150, 120)
	world.add_child(amigo)
	runner.face(amigo, "left")

	amigo2 = Character.new()
	amigo2.character_id = "crianca"
	amigo2.position = Vector2(235, 85)
	world.add_child(amigo2)
	runner.face(amigo2, "right")

	camera.position = Vector2(150, 105)
	camera.zoom = Vector2(1.15, 1.15)

	# Entrada suave
	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# Amigo fala com Miguel
	await runner.say(["c1_s3_amigo_1", "c1_s3_miguel_1"])
	await runner.wait(0.4)
	await runner.say(["c1_s3_miguel_celular"])

	# Miguel pega o celular
	phone = PhoneOverlay.new()
	add_child(phone)

	var insta := InstagramApp.new()
	phone.open(insta)
	insta.setup(InstagramApp.Mode.MIGUEL_ACCEPT_MARIA)

	await runner.wait(0.4)
	await runner.say(["c1_s3_miguel_notif"])

	# Aguarda jogador aceitar a solicitação
	await insta.action_completed

	await runner.say(["c1_s3_miguel_aceitou"])

	# Fecha o celular
	await phone.close()
	await runner.wait(0.6)

	# Câmera afasta lentamente, a conversa com amigos continua
	var t := create_tween().set_parallel(true)
	t.tween_property(camera, "zoom", Vector2(1.0, 1.0), 2.0).set_trans(Tween.TRANS_SINE)
	t.tween_property(camera, "position", Vector2(160, 90), 2.0).set_trans(Tween.TRANS_SINE)
	if ambient_player != null and is_instance_valid(ambient_player):
		t.tween_property(ambient_player, "volume_db", -40.0, 2.0)
	await t.finished

	await runner.wait(0.5)
	await runner.fade_black(1.2)

	if ambient_player != null and is_instance_valid(ambient_player):
		ambient_player.stop()
		ambient_player.queue_free()

	GameState.scene_id = "scene_04"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

extends Node
## CAPÍTULO 1 — CENA 02: A SOLICITAÇÃO DO INSTAGRAM. Gameplay interativo.
## Maria Fernanda abre o celular na calçada e encontra o perfil de Miguel no Instagram.
## O jogador clica em "Seguir" para enviar a solicitação.
## Maria guarda o celular e a cena escurece.

const SUNSET := Color(1.0, 0.88, 0.74)
const NEXT_SCENE := "res://chapters/chapter_1/scene_03_festa_amigo/scene_03.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var maria: Character
var phone: PhoneOverlay


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_02"

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

	maria = Character.new()
	maria.character_id = "maria_fernanda"
	maria.position = Vector2(178, 280)
	world.add_child(maria)
	runner.face(maria, "down")

	camera.position = maria.position
	camera.zoom = Vector2(1.2, 1.2)

	await runner.fade_from_black(0.6)
	await runner.wait(0.4)

	# Maria diz que encontrou o perfil
	await runner.say(["c1_s2_maria_busca"])

	# Abre o celular com o Instagram no perfil de Miguel
	phone = PhoneOverlay.new()
	add_child(phone)

	var insta := InstagramApp.new()
	phone.open(insta)
	insta.setup(InstagramApp.Mode.MARIA_FOLLOW_MIGUEL)

	# Aguarda o jogador clicar no botão "Seguir"
	await insta.action_completed

	# Maria comemora que enviou
	await runner.say(["c1_s2_maria_enviou"])

	# Fecha o celular
	await phone.close()
	await runner.wait(0.5)

	# Maria dá mais alguns passos e a tela escurece
	runner.walk_to(maria, Vector2(178, 330))
	await runner.wait(0.6)

	await runner.fade_black(1.0)
	GameState.scene_id = "scene_03"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

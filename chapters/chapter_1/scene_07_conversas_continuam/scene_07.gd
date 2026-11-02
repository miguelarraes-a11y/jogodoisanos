extends Node
## CAPÍTULO 1 — CENA 07: AS CONVERSAS CONTINUAM. Montagem narrativa.
## Montagem cinematográfica demonstrando a passagem dos dias e o crescimento
## natural das conversas entre Miguel e Maria Fernanda.
## Mudanças sutis de iluminação (manhã, tarde, noite) e movimentação serena dos pets.

const NEXT_SCENE := "res://chapters/chapter_1/scene_08_convite_acai/scene_08.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_07"

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

	camera.position = Vector2(160, 90)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	# --- 1) Manhã ---
	living_room.light.color = Color(1.0, 0.95, 0.85)
	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Gato anda um pouco pela sala
	runner.walk_to(living_room.cat, Vector2(100, 115))
	await runner.say(["c1_s7_narrador_1"])
	await runner.wait(0.8)

	# --- 2) Tarde (luz de entardecer) ---
	var t1 := create_tween()
	t1.tween_property(living_room.light, "color", Color(1.0, 0.88, 0.72), 1.5)
	await t1.finished

	# Notificação de mensagem
	AudioManager.play_sfx("phone_notification", -4.0)
	await runner.wait(0.5)
	runner.face(miguel, "down")

	await runner.say(["c1_s7_narrador_2"])
	await runner.wait(0.8)

	# --- 3) Noite (luz noturna acolhedora) ---
	var t2 := create_tween()
	t2.tween_property(living_room.light, "color", Color(0.80, 0.78, 0.92), 1.5)
	await t2.finished

	# Bulldog se ajeita na caminha
	runner.face(living_room.bulldog, "left")
	await runner.wait(0.6)

	await runner.say(["c1_s7_narrador_3"])
	await runner.wait(1.2)

	# Transição para a Cena 08
	await runner.fade_black(1.2)
	GameState.scene_id = "scene_08"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

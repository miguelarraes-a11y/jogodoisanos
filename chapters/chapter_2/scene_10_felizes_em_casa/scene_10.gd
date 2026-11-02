extends Node
## CAPÍTULO 2 — CENA 10: FELIZES EM CASA
## Cutscene em dois ambientes mostrando a repercussão do encontro nos dois.
## Ambiente 1: Maria Fernanda em seu quarto, radiante de felicidade.
## Ambiente 2: Miguel em sua sala, acolhido pelo seu buldogue preto e seu gato cinza.

const NEXT_SCENE := "res://chapters/chapter_2/scene_11_mensagem_agradecimento/scene_11.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
	GameState.scene_id = "scene_10"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	# --- PARTE 1: MARIA FERNANDA EM CASA ---
	var maria_room := Node2D.new()
	stage.add_child(maria_room)

	PropFactory.make_ground(maria_room, "floor_ceramic", Rect2(0, 0, 320, 180), -3)
	PropFactory.make_ground(maria_room, "wall_miguel", Rect2(0, 0, 320, 50), -2)

	var m_world := Node2D.new()
	m_world.y_sort_enabled = true
	maria_room.add_child(m_world)

	PropFactory.make_prop(m_world, "window_curtain", Vector2(160, 42))
	PropFactory.make_prop(m_world, "pet_bed", Vector2(60, 120))
	PropFactory.make_prop(m_world, "tree", Vector2(270, 70))

	var m_light := CanvasModulate.new()
	m_light.color = Color(0.92, 0.88, 0.98) # luz noturna suave
	maria_room.add_child(m_light)

	var maria := Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(160, 110)
	m_world.add_child(maria)
	runner.face(maria, "down")

	camera.position = Vector2(160, 95)
	camera.zoom = Vector2(1.2, 1.2)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	# Maria anda um pouco pelo quarto, pensativa e com um sorriso leve
	await runner.walk_to(maria, Vector2(175, 110))
	runner.face(maria, "left")
	await runner.wait(0.6)
	runner.face(maria, "down")
	await runner.wait(1.4)

	await runner.fade_black(1.0)
	maria_room.queue_free()

	# --- PARTE 2: MIGUEL EM CASA COM SEUS PETS ---
	var living_room := MiguelLivingRoom.new()
	stage.add_child(living_room)

	# Miguel em casa (com o sprite do encontro)
	var miguel := Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(285, 105)
	living_room.world.add_child(miguel)
	runner.face(miguel, "left")

	if living_room.light:
		living_room.light.color = Color(0.92, 0.90, 0.85)

	camera.target = miguel
	camera.position = Vector2(170, 95)
	camera.zoom = Vector2(1.1, 1.1)

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Miguel caminha até o sofá
	await runner.walk_to(miguel, Vector2(170, 102))
	runner.face(miguel, "down")
	await runner.wait(0.5)

	# Os bichinhos (buldogue preto e gato cinza) se aproximam dele
	if is_instance_valid(living_room.bulldog):
		runner.walk_to(living_room.bulldog, Vector2(145, 112))
		runner.face(living_room.bulldog, "right")
	if is_instance_valid(living_room.cat):
		runner.walk_to(living_room.cat, Vector2(195, 110))
		runner.face(living_room.cat, "left")

	await runner.wait(1.0)

	# Pensamento / fala de Miguel
	await runner.say(["c2_s10_miguel_sorriso"])
	await runner.wait(1.2)

	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

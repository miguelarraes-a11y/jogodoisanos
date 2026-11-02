extends Node
## CAPÍTULO 4 — CENA 10: MIGUEL CONHECE A FAMÍLIA DE MARIA FERNANDA
## Sala de estar da casa da família de Maria Fernanda.
## Encontro caloroso, apresentação de Miguel e café em família.

const NEXT_SCENE := "res://chapters/chapter_4/scene_11_encerramento/scene_11.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character
var fam_maria_1: FamilyNpc
var fam_maria_2: FamilyNpc


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	var room := Node2D.new()
	stage.add_child(room)

	# Piso e paredes da casa de Maria
	PropFactory.make_ground(room, "floor_ceramic", Rect2(0, 0, 320, 180), -3)
	PropFactory.make_ground(room, "wall_maria", Rect2(0, 0, 320, 54), -2)
	PropFactory.make_ground(room, "baseboard", Rect2(0, 52, 320, 4), -1)

	world = Node2D.new()
	world.y_sort_enabled = true
	room.add_child(world)

	# Móveis e decorações
	PropFactory.make_prop(world, "window_curtain", Vector2(70, 42))
	PropFactory.make_prop(world, "window_curtain", Vector2(250, 42))
	PropFactory.make_prop(world, "door_wood", Vector2(295, 52))
	PropFactory.make_prop(world, "sofa", Vector2(170, 106))
	PropFactory.make_prop(world, "party_table", Vector2(170, 130))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.97, 0.92)
	stage.add_child(light)

	# Familiares de Maria Fernanda no sofá
	fam_maria_1 = FamilyNpc.new("family_member_b", "Família de Maria")
	fam_maria_1.position = Vector2(155, 95)
	world.add_child(fam_maria_1)
	runner.face(fam_maria_1, "right")

	fam_maria_2 = FamilyNpc.new("family_member_a", "Família de Maria")
	fam_maria_2.position = Vector2(185, 95)
	world.add_child(fam_maria_2)
	runner.face(fam_maria_2, "right")

	# Maria Fernanda recebe Miguel na entrada
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(265, 95)
	world.add_child(maria)
	runner.face(maria, "left")

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(295, 75)
	world.add_child(miguel)
	runner.face(miguel, "down")

	camera.position = Vector2(160, 90)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Miguel entra na sala acompanhado de Maria
	await runner.walk_to(miguel, Vector2(265, 110))
	runner.face(miguel, "left")
	await runner.wait(0.4)

	await runner.say(["c4_s10_chegada_miguel"])
	await runner.wait(0.3)
	await runner.say(["c4_s10_apresentacao_maria"])
	await runner.wait(0.4)
	await runner.say(["c4_s10_familiar_maria_1"])
	await runner.wait(0.4)
	await runner.say(["c4_s10_miguel_agradecido"])
	await runner.wait(0.6)

	await runner.say(["c4_s10_ambiente_familia"])
	await runner.wait(1.5)

	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.4)

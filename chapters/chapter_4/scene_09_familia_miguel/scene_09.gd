extends Node
## CAPÍTULO 4 — CENA 09: MARIA FERNANDA CONHECE A FAMÍLIA DE MIGUEL
## Sala de estar da casa de Miguel com os pets (buldogue preto e gato cinza)
## e familiares em um acolhedor primeiro encontro.

const NEXT_SCENE := "res://chapters/chapter_4/scene_10_familia_maria/scene_10.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom

var maria: Character
var fam_a: FamilyNpc
var fam_b: FamilyNpc


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
	GameState.scene_id = "scene_09"

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
	var miguel := living_room.spawn_miguel(Vector2(265, 95))
	runner.face(miguel, "left")

	# Familiares de Miguel reunidos na sala (provisórios e configuráveis)
	fam_a = FamilyNpc.new("family_member_a", "Família de Miguel")
	fam_a.position = Vector2(175, 90)
	living_room.world.add_child(fam_a)
	runner.face(fam_a, "right")

	fam_b = FamilyNpc.new("family_member_b", "Família de Miguel")
	fam_b.position = Vector2(200, 95)
	living_room.world.add_child(fam_b)
	runner.face(fam_b, "right")

	# Maria Fernanda chega pela porta da sala
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(295, 75)
	living_room.world.add_child(maria)
	runner.face(maria, "down")

	camera.position = Vector2(160, 90)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Maria entra na sala ao lado de Miguel
	await runner.walk_to(maria, Vector2(265, 110))
	runner.face(maria, "left")
	await runner.wait(0.4)

	# Apresentação e acolhimento
	await runner.say(["c4_s9_chegada_maria"])
	await runner.wait(0.3)
	await runner.say(["c4_s9_apresentacao_miguel"])
	await runner.wait(0.4)
	await runner.say(["c4_s9_familiar_miguel_1"])
	await runner.wait(0.4)
	await runner.say(["c4_s9_maria_timida_feliz"])
	await runner.wait(0.6)

	# Narração do clima acolhedor
	await runner.say(["c4_s9_ambiente_acolhedor"])
	await runner.wait(1.5)

	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.4)

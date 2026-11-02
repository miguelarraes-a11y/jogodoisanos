extends Node
## CAPÍTULO 2 — CENA 05: DECISÃO DE IR ATÉ A QUADRA
## O casal termina o açaí. O encontro está tão gostoso que nenhum dos dois quer que acabe.
## Miguel convida Maria para conhecer a quadra e ela aceita, pedindo para aprender a arremessar.

const NEXT_SCENE := "res://chapters/chapter_2/scene_06_caminhada_quadra/scene_06.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
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
	var shop := Node2D.new()
	stage.add_child(shop)

	PropFactory.make_ground(shop, "floor_ceramic", Rect2(0, 0, 320, 180), -2)

	var world := Node2D.new()
	world.y_sort_enabled = true
	shop.add_child(world)

	PropFactory.make_ground(shop, "wall_miguel", Rect2(0, 0, 320, 48), -1)

	PropFactory.make_prop(world, "acai_table", Vector2(160, 105), Vector2(36, 16))
	PropFactory.make_prop(world, "party_chair", Vector2(136, 105))
	PropFactory.make_prop(world, "party_chair", Vector2(184, 105))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(136, 102)
	world.add_child(miguel)
	runner.face(miguel, "right")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(184, 102)
	world.add_child(maria)
	runner.face(maria, "left")

	camera.target = miguel
	camera.position = Vector2(160, 100)
	camera.zoom = Vector2(1.2, 1.2)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(0.8)
	await runner.wait(0.5)

	# Fim do açaí
	await runner.say(["c2_s5_acabou"])
	await runner.wait(0.4)

	# Miguel propõe esticar o passeio até a quadra
	await runner.say(["c2_s5_proposta_miguel"])
	await runner.wait(0.3)

	# Maria aceita com entusiasmo
	await runner.say(["c2_s5_aceite_maria"])
	await runner.wait(0.3)
	await runner.say(["c2_s5_miguel_promessa"])
	await runner.wait(0.5)

	# Os dois levantam e vão em direção à porta
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(150, 165)),
		runner.walk_to.bind(maria, Vector2(170, 165))
	])
	runner.face(miguel, "down")
	runner.face(maria, "down")
	await runner.wait(0.4)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

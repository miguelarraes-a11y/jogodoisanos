extends Node
## CAPÍTULO 2 — CENA 03: AÇAITERIA & MINIGAME DE MONTAR O AÇAÍ
## Miguel e Maria chegam à açaiteria do bairro.
## O jogador monta o açaí através do minigame e em seguida o casal vai para a mesa.

const NEXT_SCENE := "res://chapters/chapter_2/scene_04_conversa_acai/scene_04.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var atendente: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
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
	var shop := Node2D.new()
	stage.add_child(shop)

	# Chão da açaiteria
	PropFactory.make_ground(shop, "floor_ceramic", Rect2(0, 0, 320, 180), -2)

	var world := Node2D.new()
	world.y_sort_enabled = true
	shop.add_child(world)

	# Parede de fundo com detalhes acolhedores
	PropFactory.make_ground(shop, "wall_miguel", Rect2(0, 0, 320, 48), -1)

	# Balcão de atendimento e vitrine
	PropFactory.make_prop(world, "acai_counter", Vector2(160, 68), Vector2(48, 20))

	# Mesas e cadeiras da açaiteria (cadeiras sem colisão para sentar perfeitamente)
	PropFactory.make_prop(world, "acai_table", Vector2(70, 120), Vector2(36, 16))
	PropFactory.make_prop(world, "party_chair", Vector2(50, 120))
	PropFactory.make_prop(world, "party_chair", Vector2(90, 120))

	PropFactory.make_prop(world, "acai_table", Vector2(250, 120), Vector2(36, 16))
	PropFactory.make_prop(world, "party_chair", Vector2(230, 120))
	PropFactory.make_prop(world, "party_chair", Vector2(270, 120))

	# Planta decorativa de canto
	PropFactory.make_prop(world, "tree", Vector2(20, 60))

	# Luz agradável e quente do interior da loja
	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.92)
	stage.add_child(light)

	# Atendente atrás do balcão
	atendente = Character.new()
	atendente.character_id = "morador"
	atendente.position = Vector2(160, 50)
	world.add_child(atendente)
	runner.face(atendente, "down")

	# Miguel e Maria entrando
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(150, 170)
	world.add_child(miguel)
	runner.face(miguel, "up")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(170, 172)
	world.add_child(maria)
	runner.face(maria, "up")

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.4)

	# Caminham até o balcão
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(150, 85)),
		runner.walk_to.bind(maria, Vector2(170, 85))
	])
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.wait(0.5)

	# Diálogo de atendimento
	await runner.say(["c2_s3_atendente"])
	await runner.wait(0.3)
	await runner.say(["c2_s3_miguel_pedido"])
	await runner.wait(0.4)

	# Inicia o minigame de montar o açaí
	var minigame := AcaiMinigame.new()
	add_child(minigame)
	var order_result: Dictionary = await minigame.run()
	GameState.set_flag("acai_order", order_result)
	minigame.queue_free()

	await runner.wait(0.8)

	# Atendente entrega os potes
	runner.face(atendente, "down")
	await runner.wait(0.5)

	# O casal caminha até a mesa aconchegante da esquerda
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(50, 120)),
		runner.walk_to.bind(maria, Vector2(90, 120))
	])
	runner.face(miguel, "right")
	runner.face(maria, "left")
	await runner.wait(0.6)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

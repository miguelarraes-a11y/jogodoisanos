extends Node
## CAPÍTULO 4 — CENA 03: VIAGEM DE ÔNIBUS
## Interior do ônibus urbano com vista das serras de Petrópolis.
## Miguel e Maria Fernanda conversam lado a lado com escolhas interativas.

const NEXT_SCENE := "res://chapters/chapter_4/scene_04_chegada_parque/scene_04.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var bus_engine: AudioStreamPlayer


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_4"
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
	bus_engine = AudioManager.play_sfx("bus_engine", -6.0, true)

	var interior := Sprite2D.new()
	interior.texture = load("res://assets/tiles/bus_interior.png")
	interior.centered = false
	stage.add_child(interior)

	# Personagens sentados lado a lado no banco azul (x=95, y=105)
	var world := Node2D.new()
	world.y_sort_enabled = true
	stage.add_child(world)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(92, 108)
	world.add_child(miguel)
	miguel.sprite.play("idle_right")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(108, 108)
	world.add_child(maria)
	maria.sprite.play("idle_left")

	# Leve balanço do ônibus
	_add_bus_vibration(interior)
	_add_bus_vibration(miguel)
	_add_bus_vibration(maria)

	camera.position = Vector2(160, 90)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.8)

	await runner.say(["c4_s3_janela_inicio"])
	await runner.wait(0.4)

	# Escolha de diálogo do jogador
	var choice: String = String(await runner.choose([
		{"id": "serra", "label": "Elogiar a vista das montanhas"},
		{"id": "companhia", "label": "Dizer que o melhor é a companhia dela"}
	]))

	if choice == "serra":
		await runner.say(["c4_s3_opcao_serra_a"])
	else:
		await runner.say(["c4_s3_opcao_serra_b"])

	await runner.wait(0.3)
	await runner.say(["c4_s3_maria_resposta"])
	await runner.wait(1.0)

	# Transição rápida de trajeto (montagem curta do caminho)
	await runner.say(["c4_s3_chegando_parque"])
	await runner.wait(0.8)

	if bus_engine != null:
		AudioManager.stop_player(bus_engine, 0.8)

	await runner.fade_black(1.2)
	SceneManager.change_scene(NEXT_SCENE, 0.4)


func _add_bus_vibration(node: CanvasItem) -> void:
	var tw := node.create_tween().set_loops()
	tw.tween_property(node, "position:y", node.position.y + 0.8, 0.35).set_trans(Tween.TRANS_SINE)
	tw.tween_property(node, "position:y", node.position.y, 0.35).set_trans(Tween.TRANS_SINE)

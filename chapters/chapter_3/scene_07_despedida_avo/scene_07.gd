extends Node
## CAPÍTULO 3 — CENA 07: DESPEDIDA NA CASA DA AVÓ
## Em frente ao portão da casa da avó de Maria Fernanda.
## Despedida carinhosa com abraço demorado e beijo doce de despedida.

const NIGHT_LIGHT := Color(0.55, 0.55, 0.75)
const NEXT_SCENE := "res://chapters/chapter_3/scene_08_encerramento/scene_08.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var world: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
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
	var street := Node2D.new()
	stage.add_child(street)

	world = Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	PropFactory.make_prop(world, "gate_iron", Vector2(170, 160))

	var light := CanvasModulate.new()
	light.color = NIGHT_LIGHT
	stage.add_child(light)

	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(184, 180)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(172, 178)
	world.add_child(maria)

	camera.target = maria
	camera.position = Vector2(178, 175)
	camera.zoom = Vector2(1.35, 1.35)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Ficam de frente um para o outro
	runner.face(miguel, "left")
	runner.face(maria, "right")
	await runner.wait(0.6)

	await runner.say(["c3_s7_portao"])
	await runner.wait(0.3)
	await runner.say(["c3_s7_miguel_despedida"])
	await runner.wait(0.3)
	await runner.say(["c3_s7_maria_despedida"])
	await runner.wait(0.5)

	# Abraço e beijo carinhoso de despedida
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(178, 180)),
		runner.walk_to.bind(maria, Vector2(176, 179))
	])
	runner.face(miguel, "left")
	runner.face(maria, "right")

	AudioManager.play_sfx("kiss_chime", -3.0)
	_spawn_gentle_hearts(Vector2(177, 164))

	await runner.say(["c3_s7_beijo_despedida"])
	await runner.wait(1.5)

	await runner.say(["c3_s7_tchau"])
	await runner.wait(0.4)

	# Maria entra pelo portão
	runner.face(maria, "up")
	await runner.walk_to(maria, Vector2(172, 150))
	await runner.wait(0.4)

	# Miguel sorri e começa a voltar feliz
	runner.face(miguel, "down")
	await runner.wait(1.0)

	await runner.fade_black(1.5)
	SceneManager.change_scene(NEXT_SCENE, 0.4)


func _spawn_gentle_hearts(origin: Vector2) -> void:
	var heart_tex: Texture2D = load("res://assets/sprites/ui/pixel_heart.png")
	for i in 4:
		var delay: float = i * 0.25
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_instance_valid(world):
				return
			var heart := Sprite2D.new()
			heart.texture = heart_tex
			heart.z_index = 25
			heart.position = origin + Vector2(randf_range(-6.0, 6.0), randf_range(-2.0, 2.0))
			heart.scale = Vector2(0.3, 0.3)
			heart.modulate = Color(1.0, 1.0, 1.0, 0.0)
			world.add_child(heart)

			var tw := create_tween().set_parallel(true)
			tw.tween_property(heart, "position:y", heart.position.y - randf_range(20.0, 30.0), 1.6)
			tw.tween_property(heart, "position:x", heart.position.x + randf_range(-6.0, 6.0), 1.6)

			var s_tw := create_tween()
			s_tw.tween_property(heart, "scale", Vector2(1.0, 1.0), 0.3)
			s_tw.tween_property(heart, "scale", Vector2(0.8, 0.8), 1.3)

			var a_tw := create_tween()
			a_tw.tween_property(heart, "modulate:a", 1.0, 0.2)
			a_tw.tween_interval(0.8)
			a_tw.tween_property(heart, "modulate:a", 0.0, 0.6)
			await a_tw.finished

			if is_instance_valid(heart):
				heart.queue_free()
		)

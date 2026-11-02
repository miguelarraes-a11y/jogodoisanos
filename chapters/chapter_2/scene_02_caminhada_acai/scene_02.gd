extends Node
## CAPÍTULO 2 — CENA 02: CAMINHANDO JUNTOS ATÉ O AÇAÍ
## Trecho jogável: o jogador controla Miguel caminhando pela calçada com Maria acompanhando ao lado.
## Diálogos leves e naturais acontecem ao longo do percurso.

const AFTERNOON_LIGHT := Color(1.0, 0.96, 0.90)
const NEXT_SCENE := "res://chapters/chapter_2/scene_03_acaiteria/scene_03.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var arriving: bool = false
var dialogue_step: int = 0
var hint_label: Label


func _ready() -> void:
	GameState.chapter_id = "chapter_2"
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

	# Fachada temática da Açaiteria no topo da rua
	PropFactory.make_prop(world, "acai_counter", Vector2(190, 80))

	var light := CanvasModulate.new()
	light.color = AFTERNOON_LIGHT
	stage.add_child(light)

	# Miguel controlado pelo jogador
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(188, 380)
	world.add_child(miguel)
	miguel.set_player(true)

	# Maria Fernanda acompanha ao lado
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(204, 382)
	world.add_child(maria)
	runner.face(maria, "up")

	camera.target = miguel
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	# Mostra dica de controle na tela
	_show_hint()

	await runner.fade_from_black(1.0)
	GameState.controls_locked = false


func _show_hint() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 10
	add_child(layer)

	hint_label = Label.new()
	hint_label.text = "[W, A, S, D / Setas] Caminhar com Maria até o açaí"
	hint_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint_label.set_anchors_preset(Control.PRESET_TOP_WIDE)
	hint_label.position.y = 8
	hint_label.add_theme_font_size_override("font_size", 11)
	hint_label.add_theme_color_override("font_color", Color(1.0, 0.95, 0.7))
	layer.add_child(hint_label)

	get_tree().create_timer(5.0).timeout.connect(func():
		if is_instance_valid(hint_label):
			var tw := create_tween()
			tw.tween_property(hint_label, "modulate:a", 0.0, 1.0)
			await tw.finished
			layer.queue_free()
	)


func _physics_process(delta: float) -> void:
	if arriving or miguel == null or maria == null:
		return

	# Maria acompanha suavemente Miguel
	var target_pos := miguel.position + Vector2(16, 2)
	var diff := target_pos - maria.position
	if diff.length() > 6.0:
		maria.ai_direction = diff.normalized()
		maria.ai_running = diff.length() > 30.0
	else:
		maria.ai_direction = Vector2.ZERO
		maria.ai_running = false
		maria.facing = miguel.facing

	# Gatilhos de diálogo ao longo da caminhada
	if dialogue_step == 0 and miguel.position.y < 300:
		dialogue_step = 1
		_trigger_dialogue_1()
	elif dialogue_step == 1 and miguel.position.y < 210:
		dialogue_step = 2
		_trigger_dialogue_2()
	elif miguel.position.y < 120 and not arriving:
		arriving = true
		_reach_acai()


func _trigger_dialogue_1() -> void:
	GameState.controls_locked = true
	miguel.velocity = Vector2.ZERO
	maria.ai_direction = Vector2.ZERO
	await runner.say(["c2_s2_miguel_1"])
	await runner.say(["c2_s2_maria_1"])
	GameState.controls_locked = false


func _trigger_dialogue_2() -> void:
	GameState.controls_locked = true
	miguel.velocity = Vector2.ZERO
	maria.ai_direction = Vector2.ZERO
	await runner.say(["c2_s2_miguel_2"])
	GameState.controls_locked = false


func _reach_acai() -> void:
	GameState.controls_locked = true
	miguel.set_player(false)
	miguel.velocity = Vector2.ZERO
	maria.ai_direction = Vector2.ZERO

	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.wait(0.5)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)

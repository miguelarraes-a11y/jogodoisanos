extends Node
## CAPÍTULO 2 — CENA 09: A DESPEDIDA E O PRIMEIRO SELINHO
## Em frente ao portão da casa da avó de Maria Fernanda.
## Momento de grande sensibilidade e ternura: o abraço aconchegante, o primeiro selinho do casal
## e o efeito mágico de corações em pixel art subindo suavemente ao som de sinos românticos.

const NIGHT_LIGHT := Color(0.55, 0.55, 0.75)
const NEXT_SCENE := "res://chapters/chapter_2/scene_10_felizes_em_casa/scene_10.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var world: Node2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
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
	var street := Node2D.new()
	stage.add_child(street)

	world = Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Casa e portão da avó
	PropFactory.make_prop(world, "gate_iron", Vector2(170, 160))

	# Luz da noite com poste iluminando suavemente a calçada
	var light := CanvasModulate.new()
	light.color = NIGHT_LIGHT
	stage.add_child(light)

	# Miguel e Maria chegam em frente ao portão
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(184, 180)
	world.add_child(miguel)

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(172, 178)
	world.add_child(maria)

	# Enquadramento inicial aproximado
	camera.target = maria
	camera.position = Vector2(178, 175)
	camera.zoom = Vector2(1.35, 1.35)
	camera.set_world_limits(Rect2i(0, 0, 480, 640))

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# Ficam de frente um para o outro
	runner.face(miguel, "left")
	runner.face(maria, "right")
	await runner.wait(0.8)

	# Falas da despedida
	await runner.say(["c2_s9_chegada_portao"])
	await runner.wait(0.4)
	await runner.say(["c2_s9_miguel_despedida"])
	await runner.wait(0.4)
	await runner.say(["c2_s9_maria_abraço"])
	await runner.wait(0.6)

	# O Abraço: eles se aproximam com carinho
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(178, 180)),
		runner.walk_to.bind(maria, Vector2(176, 179))
	])
	runner.face(miguel, "left")
	runner.face(maria, "right")
	await runner.wait(1.2)

	# O Selinho: zoom ainda mais intimista e efeito dos corações
	var zoom_tw := create_tween()
	zoom_tw.tween_property(camera, "zoom", Vector2(1.5, 1.5), 0.8).set_trans(Tween.TRANS_SINE)
	zoom_tw.parallel().tween_property(camera, "position", Vector2(177, 172), 0.8)
	await zoom_tw.finished

	# Toca o chime romântico
	AudioManager.play_sfx("kiss_chime", -2.0)

	# Dispara a animação dos corações flutuando
	_spawn_heart_effects(Vector2(177, 162))

	await runner.say(["c2_s9_selinho"])
	await runner.wait(1.5)

	# Câmera retorna suavemente ao zoom normal
	var unzoom := create_tween()
	unzoom.tween_property(camera, "zoom", Vector2(1.35, 1.35), 1.0).set_trans(Tween.TRANS_SINE)
	unzoom.parallel().tween_property(camera, "position", Vector2(178, 175), 1.0)
	await unzoom.finished

	# Despedida doce
	await runner.say(["c2_s9_tchau_maria"])
	await runner.say(["c2_s9_tchau_miguel"])
	await runner.wait(0.5)

	# Maria entra pelo portão da casa da avó
	runner.face(maria, "up")
	await runner.walk_to(maria, Vector2(172, 150))
	await runner.wait(0.5)

	# Miguel observa, sorri e se vira feliz
	runner.face(miguel, "down")
	await runner.wait(1.0)

	await runner.fade_black(1.5)
	SceneManager.change_scene(NEXT_SCENE, 0.3)


## Cria uma sequência graciosa de corações em pixel art flutuando suavemente para cima
func _spawn_heart_effects(origin: Vector2) -> void:
	var heart_tex: Texture2D = load("res://assets/sprites/ui/pixel_heart.png")

	# Dispara 6 corações em tempos escalonados
	for i in 6:
		var delay: float = i * 0.18
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_instance_valid(world):
				return
			var heart := Sprite2D.new()
			heart.texture = heart_tex
			heart.z_index = 25
			heart.position = origin + Vector2(randf_range(-6.0, 6.0), randf_range(-2.0, 2.0))
			heart.scale = Vector2(0.2, 0.2)
			heart.modulate = Color(1.0, 1.0, 1.0, 0.0)
			world.add_child(heart)

			var tw := create_tween().set_parallel(true)
			# Sobe e oscila levemente para os lados
			var target_y := heart.position.y - randf_range(22.0, 34.0)
			var target_x := heart.position.x + randf_range(-8.0, 8.0)
			var duration := randf_range(1.4, 2.0)

			tw.tween_property(heart, "position:y", target_y, duration).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tw.tween_property(heart, "position:x", target_x, duration).set_trans(Tween.TRANS_SINE)

			# Cresce e depois desaparece suavemente
			var s_tw := create_tween()
			s_tw.tween_property(heart, "scale", Vector2(1.0, 1.0), 0.3)
			s_tw.tween_property(heart, "scale", Vector2(1.15, 1.15), duration * 0.4)
			s_tw.tween_property(heart, "scale", Vector2(0.8, 0.8), duration * 0.3)

			var a_tw := create_tween()
			a_tw.tween_property(heart, "modulate:a", 1.0, 0.25)
			a_tw.tween_interval(duration * 0.45)
			a_tw.tween_property(heart, "modulate:a", 0.0, duration * 0.3)
			await a_tw.finished

			if is_instance_valid(heart):
				heart.queue_free()
		)

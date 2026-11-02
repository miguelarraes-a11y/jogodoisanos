extends Node
## CAPÍTULO 1 — CENA 01: DEPOIS DO PRIMEIRO OLHAR. Cutscene cinematográfica.
## As meninas continuam caminhando pela rua após o primeiro contato visual.
## Maria Fernanda comenta que achou Miguel bonito.
## A prima o identifica e sugere que Maria o siga no Instagram.
## Maria abre o celular para procurar o perfil.

const SUNSET := Color(1.0, 0.88, 0.74)
const NEXT_SCENE := "res://chapters/chapter_1/scene_02_instagram_solicitacao/scene_02.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var maria: Character
var prima: Character
var ana: Character
var gabriele: Character
var miguel: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_01"

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

	var sunset_mod := CanvasModulate.new()
	sunset_mod.color = SUNSET
	stage.add_child(sunset_mod)

	# Miguel no fundo, descendo a rua em direção à sua casa
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = Vector2(235, 340)
	world.add_child(miguel)
	runner.face(miguel, "down")

	# As 4 meninas na calçada
	maria = Character.new()
	maria.character_id = "maria_fernanda"
	maria.position = Vector2(178, 250)
	world.add_child(maria)
	runner.face(maria, "down")

	prima = Character.new()
	prima.character_id = "prima"
	prima.position = Vector2(192, 245)
	world.add_child(prima)
	runner.face(prima, "down")

	ana = Character.new()
	ana.character_id = "ana_clara"
	ana.position = Vector2(174, 235)
	world.add_child(ana)
	runner.face(ana, "down")

	gabriele = Character.new()
	gabriele.character_id = "gabriele"
	gabriele.position = Vector2(190, 230)
	world.add_child(gabriele)
	runner.face(gabriele, "down")

	camera.target = maria
	camera.snap_to_target()
	camera.set_world_limits(Rect2i(0, 0, 320, 480))

	# Fade in inicial
	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Miguel continua descendo a rua devagar e se afasta
	runner.walk_to(miguel, Vector2(235, 420))

	# Meninas caminham juntas um pouco descendo a calçada
	await runner.parallel([
		runner.walk_to.bind(maria, Vector2(178, 280)),
		runner.walk_to.bind(prima, Vector2(192, 275)),
		runner.walk_to.bind(ana, Vector2(174, 265)),
		runner.walk_to.bind(gabriele, Vector2(190, 260)),
	])

	# Maria para e se vira para as amigas
	runner.face(maria, "up")
	runner.face(prima, "down")
	runner.face(ana, "down")
	runner.face(gabriele, "down")
	await runner.wait(0.6)

	# Diálogos
	await runner.say(["c1_s1_maria_1", "c1_s1_maria_2"])
	await runner.wait(0.3)
	await runner.say(["c1_s1_prima_1", "c1_s1_prima_2"])
	await runner.wait(0.3)
	await runner.say(["c1_s1_ana_1"])
	await runner.wait(0.3)
	await runner.say(["c1_s1_maria_3"])

	# Maria pega o celular, câmera foca nela
	await runner.wait(0.5)
	var t := create_tween()
	t.tween_property(camera, "zoom", Vector2(1.25, 1.25), 0.8).set_trans(Tween.TRANS_SINE)
	await t.finished
	await runner.wait(0.6)

	# Transição para a Cena 2
	await runner.fade_black(1.0)
	GameState.scene_id = "scene_02"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

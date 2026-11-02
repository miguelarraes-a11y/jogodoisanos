extends Node
## CENA 03 — A TARDE DE MARIA FERNANDA. Cutscene + Gameplay.
## 1) Escola: Maria Fernanda chega, tempo passa, sinal de saída toca.
## 2) Saída com amigas: sai com Ana Clara e Gabriele para pegar doces de São Cosme e Damião.
## 3) Ruas do bairro: MINIGAME CORRIDA DOS DOCES (moradores nos portões distribuindo doces).
## 4) Encerramento: amigas se reúnem, resultado, tela escurece e segue para a Cena 04.

const AFTERNOON := Color(1.0, 0.92, 0.82)
const CANDY_CONFIG := "res://data/minigames/candy_run.json"
const NEXT_SCENE := "res://chapters/prologue/scene_04_abacate/scene_04.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var maria: Character
var ana: Character
var gabriele: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "prologue"
	GameState.scene_id = "scene_03"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _clear_stage() -> void:
	for child in stage.get_children():
		child.queue_free()
	await get_tree().process_frame


func _play() -> void:
	await _phase_school()
	await _phase_candy_run()


# ---------- 1) Escola: chegada, passagem do tempo e sinal de saída ----------
func _phase_school() -> void:
	camera.target = null
	camera.set_world_limits(Rect2i(0, 0, 320, 180))
	camera.position = Vector2(160, 90)

	var school_env := Node2D.new()
	stage.add_child(school_env)

	# Chão da escola / calçada
	PropFactory.make_ground(school_env, "grass", Rect2(0, 0, 320, 180), -30)
	PropFactory.make_ground(school_env, "sidewalk", Rect2(0, 120, 320, 60), -29)

	# Fachada da escola
	var school_sprite := Sprite2D.new()
	var school_tex := load("res://assets/tiles/school.png")
	if school_tex != null:
		school_sprite.texture = school_tex
	school_sprite.position = Vector2(160, 75)
	school_env.add_child(school_sprite)

	# Árvores na calçada
	PropFactory.make_prop(school_env, "tree", Vector2(40, 130), Vector2(6, 4))
	PropFactory.make_prop(school_env, "tree", Vector2(280, 130), Vector2(6, 4))

	# Maria Fernanda chega à escola
	maria = Character.new()
	maria.character_id = "maria_fernanda"
	maria.position = Vector2(30, 145)
	school_env.add_child(maria)

	AudioManager.play_music("music_prologue", 2.0, -9.0)
	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# Caminha até o portão da escola
	await runner.walk_to(maria, Vector2(148, 140))
	runner.face(maria, "up")
	await runner.wait(0.8)

	# Passagem de tempo: fade suave simulando o turno escolar
	await runner.fade_black(1.2)
	maria.position = Vector2(150, 132) # na saída da escola
	runner.face(maria, "down")

	# Adiciona as amigas na saída
	ana = Character.new()
	ana.character_id = "ana_clara"
	ana.position = Vector2(134, 132)
	school_env.add_child(ana)
	runner.face(ana, "down")

	gabriele = Character.new()
	gabriele.character_id = "gabriele"
	gabriele.position = Vector2(166, 132)
	school_env.add_child(gabriele)
	runner.face(gabriele, "down")

	await runner.wait(0.6)
	# Toca o sinal da escola
	AudioManager.play_sfx("school_bell", -3.0)
	await runner.wait(1.5)

	# Retorna com iluminação de tarde ensolarada
	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# As três saem juntas do portão da escola
	await runner.parallel([
		runner.walk_to.bind(ana, Vector2(125, 155)),
		runner.walk_to.bind(maria, Vector2(150, 158)),
		runner.walk_to.bind(gabriele, Vector2(175, 155))
	])
	runner.face(maria, "down")
	runner.face(ana, "right")
	runner.face(gabriele, "left")

	# Diálogo introdutório sobre São Cosme e Damião
	await runner.wait(0.4)
	await runner.say(["s3_escola_saida_1", "s3_escola_saida_2", "s3_escola_saida_3", "s3_escola_saida_4", "s3_escola_saida_5"])
	await runner.wait(0.5)

	await runner.fade_black(1.0)


# ---------- 2) Ruas do bairro + Minigame de São Cosme e Damião ----------
func _phase_candy_run() -> void:
	await _clear_stage()
	camera.target = null

	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Personagens principais nas ruas
	maria = Character.new()
	maria.character_id = "maria_fernanda"
	maria.position = Vector2(235, 300)
	world.add_child(maria)

	ana = Character.new()
	ana.character_id = "ana_clara"
	ana.position = Vector2(215, 310)
	world.add_child(ana)

	gabriele = Character.new()
	gabriele.character_id = "gabriele"
	gabriele.position = Vector2(255, 310)
	world.add_child(gabriele)

	# Pontos de distribuição de doces com moradores nas portas e portões
	var candy_spots: Array = []
	var spot_data := [
		{"pos": Vector2(170, 130), "facing": "right", "stock": 4},
		{"pos": Vector2(310, 130), "facing": "left", "stock": 4},
		{"pos": Vector2(170, 280), "facing": "right", "stock": 4},
		{"pos": Vector2(310, 280), "facing": "left", "stock": 4},
		{"pos": Vector2(170, 430), "facing": "right", "stock": 4},
		{"pos": Vector2(310, 430), "facing": "left", "stock": 4},
	]

	for data in spot_data:
		var spot := CandySpot.new()
		world.add_child(spot)
		spot.setup(data["pos"], data["stock"], data["facing"])
		candy_spots.append(spot)

	# Câmera segue Maria Fernanda com limites do mundo residencial
	camera.set_world_limits(StreetBuilder.WORLD)
	camera.target = maria
	camera.snap_to_target()

	AudioManager.play_music("music_prologue", 2.0, -10.0)
	AudioManager.play_sfx("ambient_street", -12.0, true)

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# Inicia o minigame da corrida dos doces
	var mg := CandyRunMinigame.new()
	add_child(mg)
	mg.load_config(CANDY_CONFIG)
	mg.setup(maria, ana, gabriele, candy_spots, runner)

	var result: Dictionary = await mg.run()
	GameState.set_flag("candy_score_maria", result.get("maria", 0))
	GameState.set_flag("candy_score_ana", result.get("ana_clara", 0))
	GameState.set_flag("candy_score_gabriele", result.get("gabriele", 0))

	# Encerramento: amigas se reúnem
	GameState.controls_locked = true
	await runner.wait(0.5)
	await runner.parallel([
		runner.walk_to.bind(ana, maria.position + Vector2(-16, 0)),
		runner.walk_to.bind(gabriele, maria.position + Vector2(16, 0))
	])
	runner.face(maria, "down")
	runner.face(ana, "right")
	runner.face(gabriele, "left")

	await runner.wait(0.6)
	await runner.say(["s3_pos_corrida_1", "s3_pos_corrida_2", "s3_pos_corrida_3"])
	await runner.wait(1.2)
	AudioManager.stop_music(2.0)
	await runner.fade_black(1.8)

	GameState.scene_id = "scene_04"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

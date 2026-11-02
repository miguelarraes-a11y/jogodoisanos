extends Node
## CENA 02 — A MANHÃ DE MIGUEL. Cutscene + Gameplay.
## 1) Quarto: Miguel se prepara para sair.  2) Rua: a câmera acompanha a saída de casa.
## 3) Quadra coberta: chega, joga o MINIGAME DE BASQUETE (5 arremessos).
## 4) Encerramento: perde o controle, recolhe a bola, câmera mostra a quadra, escurece.
##
## PROVISÓRIO: a troca de roupa (pijama -> camiseta preta) e o caminho até a quadra
## (a quadra fica fora da rua mostrada). Nada além do descrito foi inventado.

const MORNING := Color(1.0, 0.95, 0.86)
const NEXT_SCENE := "res://chapters/prologue/scene_03_tarde_maria/scene_03.tscn"
const BASKETBALL_CONFIG := "res://data/minigames/basketball.json"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var miguel: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "prologue"
	GameState.scene_id = "scene_02"
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
	await _phase_room()
	await _phase_street()
	await _phase_court()


# ---------- 1) quarto: se prepara para sair ----------
func _phase_room() -> void:
	var room := MiguelRoom.new()
	stage.add_child(room)
	room.light.color = MORNING
	room.sleeper.hide() # a cama já está vazia
	miguel = room.spawn_standing("miguel_pijama", Vector2(190, 70))
	miguel.facing = "up"
	camera.set_world_limits(Rect2i(0, 0, 320, 180))
	camera.position = Vector2(160, 90)
	await runner.wait(1.4)
	# prepara-se para sair (provisório: troca a roupa atrás de um fade rápido)
	await runner.fade_black(0.5)
	miguel.sprite.sprite_frames = CharacterSprites.build("miguel")
	await runner.wait(0.4)
	await runner.fade_from_black(0.5)
	await runner.wait(0.6)
	await runner.walk_to(miguel, Vector2(296, 62))
	runner.face(miguel, "up")
	await runner.wait(0.4)
	await runner.fade_black(0.7)


# ---------- 2) rua: a câmera acompanha a saída de casa ----------
func _phase_street() -> void:
	await _clear_stage()
	var street := Node2D.new()
	stage.add_child(street)
	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)
	StreetBuilder.build(street, world)
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = Vector2(136, 190) # porta da primeira casa da esquerda
	world.add_child(miguel)
	camera.set_world_limits(StreetBuilder.WORLD)
	camera.target = miguel
	camera.snap_to_target()
	await runner.fade_from_black(0.8)
	await runner.wait(0.4)
	await runner.say(["s2_miguel_saindo"])
	await runner.walk_path(miguel, [Vector2(188, 190), Vector2(240, 190), Vector2(240, 60)])
	await runner.wait(0.3)
	AudioManager.stop_music(2.5)
	await runner.fade_black(1.0)


# ---------- 3) quadra coberta + minigame ----------
func _phase_court() -> void:
	await _clear_stage()
	camera.target = null
	camera.set_world_limits(Rect2i(0, 0, 320, 180))
	camera.position = Vector2(160, 90)
	camera.zoom = Vector2.ONE
	var court := BasketballCourt.new()
	stage.add_child(court)
	miguel = Character.new()
	miguel.character_id = "miguel_ball"
	miguel.position = Vector2(-14, 150)
	court.actors.add_child(miguel)

	await runner.fade_from_black(1.0)
	await runner.wait(1.4) # a câmera mostra a quadra antes de Miguel entrar
	var mg := BasketballMinigame.new()
	add_child(mg)
	mg.load_config(BASKETBALL_CONFIG)
	mg.setup(court, miguel, runner)
	await runner.parallel([_dribble.bind(4), runner.walk_to.bind(miguel, mg.get_spot(0))])
	runner.face(miguel, "up")
	await runner.wait(0.5)
	await runner.say(["s2_miguel_quadra"])

	var result: Dictionary = await mg.run()
	GameState.set_flag("basketball_score", result.get("score", 0))

	# ---------- 4) encerramento: perde o controle, recolhe a bola, câmera, escurece ----------
	GameState.controls_locked = true
	await runner.wait(0.4)
	await mg.collect_ball()
	await runner.say(["s2_miguel_fim"])
	await runner.wait(1.6) # a câmera mostra brevemente a quadra
	await runner.fade_black(1.8)
	GameState.scene_id = "scene_03"
	GameState.set_flag("next_label", "Cena 03 — A tarde de Maria Fernanda\n(será criada na Etapa 5)")
	GameState.set_flag("retry_path", "res://chapters/prologue/scene_02_manha_miguel/scene_02.tscn")
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.3)


func _dribble(times: int) -> void:
	for i in times:
		AudioManager.play_sfx("ball_bounce", -8.0)
		await runner.wait(0.45)

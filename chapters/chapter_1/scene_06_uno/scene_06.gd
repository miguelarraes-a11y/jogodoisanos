extends Node
## CAPÍTULO 1 — CENA 06: A PARTIDA DE UNO. Minigame Interativo.
## Maria Fernanda desafia Miguel para uma partida de UNO pelo celular.
## O jogador joga uma partida completa contra a IA desafiadora de Maria Fernanda.
## Após a partida, os dois trocam mensagens comentando o jogo.

const NEXT_SCENE := "res://chapters/chapter_1/scene_07_conversas_continuam/scene_07.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var living_room: MiguelLivingRoom


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_1"
	GameState.scene_id = "scene_06"

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
	living_room.spawn_miguel(Vector2(170, 102))

	camera.position = Vector2(170, 95)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(0.6)
	await runner.wait(0.4)

	# Desafio do UNO pelas mensagens
	await runner.say(["c1_s6_convite_uno", "c1_s6_miguel_topa", "c1_s6_maria_desafio"])
	await runner.wait(0.5)

	# Inicia o minigame de UNO
	var mg := UnoMinigame.new()
	add_child(mg)
	var result: Dictionary = await mg.run()
	mg.queue_free()

	GameState.set_flag("uno_winner", result.get("winner", "maria"))

	await runner.wait(0.5)

	# Diálogo pós-partida
	await runner.say(["c1_s6_pos_partida_miguel", "c1_s6_pos_partida_maria"])
	await runner.wait(0.8)

	# Transição para a Cena 07
	await runner.fade_black(1.0)
	GameState.scene_id = "scene_07"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.4)

extends Node
## CAPÍTULO 3 — CENA 03: O BANCO DE PEDRA
## Miguel e Maria Fernanda sentados lado a lado no banco de pedra.
## Conversa profunda, carinhosa e natural com opções de resposta para o jogador.

const NEXT_SCENE := "res://chapters/chapter_3/scene_04_tirando_fotos/scene_04.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character
var bench: StaticBody2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_3"
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
	AudioManager.play_music("music_closer_to_you", 1.0, -4.0)

	var park := Node2D.new()
	stage.add_child(park)

	# Gramado fresco e calçada suave da praça
	PropFactory.make_ground(park, "grass", Rect2(0, 0, 320, 180), -4)
	PropFactory.make_ground(park, "sidewalk", Rect2(120, 140, 80, 40), -3)

	var world := Node2D.new()
	world.y_sort_enabled = true
	park.add_child(world)

	# Árvores frondosas que criam a sombra do banco de pedra
	PropFactory.make_prop(world, "tree", Vector2(70, 75))
	PropFactory.make_prop(world, "tree", Vector2(250, 75))
	PropFactory.make_prop(world, "tree", Vector2(160, 50))

	# O Banco de Pedra central (sem colisão para os personagens sentarem perfeitamente)
	bench = PropFactory.make_prop(world, "banco_pedra", Vector2(160, 102))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	# Miguel e Maria sentados lado a lado no banco de pedra
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(152, 98)
	world.add_child(miguel)
	runner.face(miguel, "down")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(168, 98)
	world.add_child(maria)
	runner.face(maria, "down")

	camera.target = miguel
	camera.position = Vector2(160, 95)
	camera.zoom = Vector2(1.2, 1.2)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# Maria elogia o lugar
	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.say(["c3_s3_banco_sentei"])
	await runner.wait(0.4)

	# Pergunta sobre a semana no SESI
	await runner.say(["c3_s3_pergunta_dia"])

	# Escolha de resposta para Miguel (Tímida, Engraçada ou Carinhosa)
	var choice1: String = await _ask_choice([
		{"id": "c3_s3_opcao_timida", "label": "Tímida: Foi tranquila... Passei a semana esperando hoje."},
		{"id": "c3_s3_opcao_engracada", "label": "Engraçada: Puxada! Mas sobrevivi pensando no encontro haha."},
		{"id": "c3_s3_opcao_carinhosa", "label": "Carinhosa: Boa, mas nada se compara a estar aqui com você."}
	])
	await runner.say([choice1])
	await runner.wait(0.4)

	# Reação de Maria sobre a semana
	await runner.say(["c3_s3_maria_reacao_semana"])
	await runner.wait(0.5)

	# Maria pergunta dos pets de Miguel
	await runner.say(["c3_s3_pergunta_pets"])
	await runner.say(["c3_s3_miguel_pets_fala"])
	await runner.wait(0.4)
	await runner.say(["c3_s3_maria_carinho"])
	await runner.wait(0.6)

	# Momento de conexão e intimidade
	var zoom_tw := create_tween()
	zoom_tw.tween_property(camera, "zoom", Vector2(1.35, 1.35), 1.0).set_trans(Tween.TRANS_SINE)
	await zoom_tw.finished

	await runner.say(["c3_s3_momento_conexao"])
	await runner.wait(0.4)
	await runner.say(["c3_s3_miguel_concorda"])
	await runner.wait(0.8)

	# Segue direto para a ideia de tirar fotos
	SceneManager.change_scene(NEXT_SCENE, 0.4)


func _ask_choice(options: Array) -> String:
	var layer := CanvasLayer.new()
	layer.layer = 25
	add_child(layer)

	var panel := Panel.new()
	panel.size = Vector2(290, 24 + options.size() * 22)
	panel.position = Vector2(15, 105)
	panel.add_theme_stylebox_override("panel", UiStyle.box())
	layer.add_child(panel)

	var title := UiStyle.make_label("Como responder?", 12, Color(0.9, 0.8, 0.4))
	title.position = Vector2(10, 4)
	title.size = Vector2(270, 14)
	panel.add_child(title)

	var chosen_id := {"val": ""}
	var selected_idx := {"val": 0}
	var buttons: Array[Button] = []

	for i in range(options.size()):
		var opt: Dictionary = options[i]
		var btn := Button.new()
		btn.text = "[%d] %s" % [i + 1, opt["label"]]
		btn.position = Vector2(10, 20 + i * 22)
		btn.size = Vector2(270, 18)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.add_theme_font_size_override("font_size", 11)
		btn.add_theme_color_override("font_color", Color.WHITE)
		panel.add_child(btn)
		buttons.append(btn)

		var id: String = opt["id"]
		btn.pressed.connect(func():
			chosen_id["val"] = id
		)

	var update_highlight = func():
		for idx in range(buttons.size()):
			if idx == selected_idx["val"]:
				buttons[idx].add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
			else:
				buttons[idx].add_theme_color_override("font_color", Color.WHITE)

	update_highlight.call()

	while chosen_id["val"] == "":
		if Input.is_action_just_pressed("ui_down") or Input.is_action_just_pressed("move_down"):
			selected_idx["val"] = (selected_idx["val"] + 1) % options.size()
			update_highlight.call()
		elif Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("move_up"):
			selected_idx["val"] = (selected_idx["val"] - 1 + options.size()) % options.size()
			update_highlight.call()
		elif Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("ui_accept"):
			chosen_id["val"] = options[selected_idx["val"]]["id"]
		elif Input.is_key_pressed(KEY_1) and options.size() > 0:
			chosen_id["val"] = options[0]["id"]
		elif Input.is_key_pressed(KEY_2) and options.size() > 1:
			chosen_id["val"] = options[1]["id"]
		elif Input.is_key_pressed(KEY_3) and options.size() > 2:
			chosen_id["val"] = options[2]["id"]
		await get_tree().process_frame

	layer.queue_free()
	return chosen_id["val"]

extends Node
## CAPÍTULO 2 — CENA 04: CONVERSA NO AÇAÍ
## Miguel e Maria Fernanda conversam na mesa enquanto tomam açaí.
## O jogador faz pequenas escolhas de diálogo para Miguel.
## Assuntos: onde estudam (SESI e Liceu), bichinhos (buldogue preto e gato cinza) e o clima do encontro.

const NEXT_SCENE := "res://chapters/chapter_2/scene_05_decisao_quadra/scene_05.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D

var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
	GameState.scene_id = "scene_04"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_first_date", 1.0, -4.0)

	var shop := Node2D.new()
	stage.add_child(shop)

	PropFactory.make_ground(shop, "floor_ceramic", Rect2(0, 0, 320, 180), -2)

	var world := Node2D.new()
	world.y_sort_enabled = true
	shop.add_child(world)

	PropFactory.make_ground(shop, "wall_miguel", Rect2(0, 0, 320, 48), -1)

	# Mesa central da conversa com as duas tigelas de açaí
	PropFactory.make_prop(world, "acai_table", Vector2(160, 105), Vector2(36, 16))
	PropFactory.make_prop(world, "party_chair", Vector2(136, 105))
	PropFactory.make_prop(world, "party_chair", Vector2(184, 105))

	# Decorações ao fundo
	PropFactory.make_prop(world, "tree", Vector2(40, 55))
	PropFactory.make_prop(world, "tree", Vector2(280, 55))

	var light := CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90)
	stage.add_child(light)

	# Miguel sentado na cadeira da esquerda (olhando para a direita)
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(136, 102)
	world.add_child(miguel)
	runner.face(miguel, "right")

	# Maria sentada na cadeira da direita (olhando para a esquerda)
	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(184, 102)
	world.add_child(maria)
	runner.face(maria, "left")

	camera.target = miguel
	camera.position = Vector2(160, 100)
	camera.zoom = Vector2(1.2, 1.2)
	camera.set_world_limits(Rect2i(0, 0, 320, 180))

	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# 1. Início da conversa: Maria elogia o açaí
	await runner.say(["c2_s4_inicio"])
	await runner.wait(0.4)

	# 2. Pergunta sobre a escola
	await runner.say(["c2_s4_escola_maria"])
	var choice1: String = await _ask_choice([
		{"id": "c2_s4_escola_miguel_a", "label": "Estudo no SESI! É bem puxado, mas até que gosto."},
		{"id": "c2_s4_escola_miguel_b", "label": "Tô no SESI. A galera de lá é bem gente boa!"}
	])
	await runner.say([choice1])
	await runner.wait(0.3)

	# Maria fala sobre o Liceu
	await runner.say(["c2_s4_maria_liceu"])
	await runner.wait(0.5)

	# 3. Pergunta sobre animais de estimação
	await runner.say(["c2_s4_pets_intro"])
	var choice2: String = await _ask_choice([
		{"id": "c2_s4_miguel_pets_a", "label": "Tenho um buldogue preto preguiçoso e um gato cinza!"},
		{"id": "c2_s4_miguel_pets_b", "label": "Buldogue preto e gato cinza, vivem na sala comigo haha."}
	])
	await runner.say([choice2])
	await runner.wait(0.3)

	# Reação fofa de Maria sobre os pets
	await runner.say(["c2_s4_maria_pets"])
	await runner.wait(0.5)

	# 4. Momento de conexão e presença
	await runner.say(["c2_s4_rotina"])
	var choice3: String = await _ask_choice([
		{"id": "c2_s4_miguel_gostando_a", "label": "Também acho! O tempo tá até voando com você."},
		{"id": "c2_s4_miguel_gostando_b", "label": "Nem me fale... Tô muito feliz que você veio."}
	])
	await runner.say([choice3])
	await runner.wait(0.8)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)


func _ask_choice(options: Array) -> String:
	var layer := CanvasLayer.new()
	layer.layer = 25
	add_child(layer)

	var panel := Panel.new()
	panel.size = Vector2(280, 24 + options.size() * 22)
	panel.position = Vector2(20, 110)
	panel.add_theme_stylebox_override("panel", UiStyle.box())
	layer.add_child(panel)

	var title := UiStyle.make_label("O que responder?", 12, Color(0.9, 0.8, 0.4))
	title.position = Vector2(10, 4)
	title.size = Vector2(260, 14)
	panel.add_child(title)

	var chosen_id := {"val": ""}
	var selected_idx := {"val": 0}
	var buttons: Array[Button] = []

	for i in range(options.size()):
		var opt: Dictionary = options[i]
		var btn := Button.new()
		btn.text = "[%d] %s" % [i + 1, opt["label"]]
		btn.position = Vector2(10, 20 + i * 22)
		btn.size = Vector2(260, 18)
		btn.alignment = HORIZONTAL_ALIGNMENT_LEFT
		btn.flat = true
		btn.add_theme_font_size_override("font_size", 12)
		btn.add_theme_color_override("font_color", Color.WHITE)
		panel.add_child(btn)
		buttons.append(btn)

		var id: String = opt["id"]
		btn.pressed.connect(func():
			chosen_id["val"] = id
		)

	# Atualiza destaque do foco
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
		await get_tree().process_frame

	layer.queue_free()
	return chosen_id["val"]

class_name CutsceneRunner
extends Node
## Sistema reutilizável de cutscenes. Cada cutscene é um script que chama estes métodos
## com `await`, na ordem desejada. Também aceita uma lista de ações (run_actions) em dados.
##
## Recursos: bloquear/devolver controles, mover personagens, virar personagens, animar,
## mover câmera, tocar efeitos e músicas, mostrar texto, fades de tela, esperar, ações em paralelo.

signal _parallel_step


func _ready() -> void:
	_ensure_box()


func _ensure_box() -> DialogueBox:
	var box: DialogueBox = get_tree().get_first_node_in_group("dialogue_box")
	if box == null:
		box = DialogueBox.new()
		add_child(box)
	return box


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout


# --- controles ---
func lock_controls() -> void:
	GameState.controls_locked = true


func unlock_controls() -> void:
	GameState.controls_locked = false


# --- personagens ---
## Anda até o ponto (coordenadas globais do nó). Sistema anti-travamento para nunca ficar agarrado.
func walk_to(c: Character, target: Vector2, running: bool = false, timeout: float = 8.0) -> void:
	var elapsed := 0.0
	var last_pos := c.global_position
	var stuck_time := 0.0
	while c.global_position.distance_to(target) > 3.0 and elapsed < timeout:
		c.ai_direction = target - c.global_position
		c.ai_running = running
		await get_tree().physics_frame
		var delta := get_physics_process_delta_time()
		elapsed += delta
		if c.global_position.distance_to(last_pos) < 0.2:
			stuck_time += delta
			if stuck_time > 0.35:
				c.global_position = target
				break
		else:
			stuck_time = 0.0
		last_pos = c.global_position
	c.ai_direction = Vector2.ZERO
	c.ai_running = false


func walk_path(c: Character, points: Array, running: bool = false) -> void:
	for p in points:
		await walk_to(c, p, running)


func face(c: Character, direction: String) -> void:
	c.facing = direction
	c.sprite.play("idle_" + direction)


# --- animação genérica ---
func tween_prop(node: Object, property: String, to: Variant, duration: float) -> void:
	var t := create_tween()
	t.tween_property(node, property, to, duration)
	await t.finished


func move_camera(cam: Camera2D, to: Vector2, duration: float) -> void:
	await tween_prop(cam, "position", to, duration)


# --- tela ---
func fade_black(duration: float = 0.8) -> void:
	await SceneManager.fade_out(duration)


func fade_from_black(duration: float = 0.8) -> void:
	await SceneManager.fade_in(duration)


# --- áudio ---
func sfx(sound_name: String, volume_db: float = 0.0, loop: bool = false) -> AudioStreamPlayer:
	return AudioManager.play_sfx(sound_name, volume_db, loop)


func music(sound_name: String, fade: float = 1.5, volume_db: float = -6.0) -> void:
	AudioManager.play_music(sound_name, fade, volume_db)


# --- texto (caixa de diálogo estilo Stardew, sem som) ---
func say(dialogue_ids: Array) -> void:
	var box := _ensure_box()
	await box.show_lines(Dialogues.get_lines(dialogue_ids))


## Menu interativo de escolha para cutscenes com botões e teclado (1/2/3, setas, Enter/Espaço).
func choose(options: Array) -> String:
	var layer := CanvasLayer.new()
	layer.layer = 25
	add_child(layer)

	var panel := Panel.new()
	panel.size = Vector2(290, 24 + options.size() * 22)
	panel.position = Vector2(15, 105)
	panel.add_theme_stylebox_override("panel", UiStyle.box())
	layer.add_child(panel)

	var title := UiStyle.make_label("O que responder?", 12, Color(0.9, 0.8, 0.4))
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


# --- paralelo: roda várias ações ao mesmo tempo e espera todas terminarem ---
func parallel(actions: Array) -> void:
	var state := {"left": actions.size()}
	for a in actions:
		_run_one(a, state)
	while state["left"] > 0:
		await _parallel_step


func _run_one(action: Callable, state: Dictionary) -> void:
	await action.call()
	state["left"] -= 1
	_parallel_step.emit()


# --- cutscene por dados: [{"do": "wait", "t": 1.0}, ...] ---
func run_actions(actions: Array) -> void:
	for a in actions:
		match a.get("do", ""):
			"wait": await wait(a.get("t", 1.0))
			"lock": lock_controls()
			"unlock": unlock_controls()
			"fade_out": await fade_black(a.get("t", 0.8))
			"fade_in": await fade_from_black(a.get("t", 0.8))
			"sfx": sfx(a["name"], a.get("db", 0.0))
			"music": music(a["name"], a.get("fade", 1.5), a.get("db", -6.0))
			"say": await say(a["ids"])
			"call": await a["fn"].call()
			_: push_warning("Ação de cutscene desconhecida: " + str(a))

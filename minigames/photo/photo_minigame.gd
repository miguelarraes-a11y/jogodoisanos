class_name PhotoMinigame
extends MiniGameBase
## Minigame fofo e leve de tirar foto / selfie no banco de pedra.
## O jogador enquadra a câmera do celular e aperta para registrar a foto lembrança do casal.

var _ui_root: Control
var _done: bool = false
var _result_data: Dictionary = {}


func _intro() -> Dictionary:
	return {
		"title": "HORA DA SELFIE!",
		"lines": [
			"Maria Fernanda pegou o celular para registrar o momento.",
			"Aperte o botão quando os dois estiverem sorrindo juntos!",
			"Espaço / Enter / Clique: Tirar a foto"
		],
		"hint": "[Espaço / Enter] Abrir Câmera",
	}


func _results(result: Dictionary) -> Dictionary:
	return {
		"title": "FOTO REGISTRADA!",
		"lines": [
			"A lembrança perfeita do encontro no banco de pedra.",
			"",
			"\"Essa foto ficou linda demais!\""
		],
		"hint": "[Espaço / Enter] Continuar conversa",
	}


func _play() -> Dictionary:
	_build_camera_ui()

	var shot_taken := false
	var t := 0.0

	var reticle: Control = _ui_root.get_node("Viewfinder/Reticle") as Control
	var hint_lbl: Label = _ui_root.get_node("Viewfinder/HintLabel") as Label

	while not shot_taken:
		t += get_process_delta_time() * 2.5
		if reticle != null:
			var scale_osc := 1.0 + sin(t) * 0.08
			reticle.scale = Vector2(scale_osc, scale_osc)

		if Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			shot_taken = true
			await _trigger_flash_and_photo()

		await get_tree().process_frame

	await get_tree().create_timer(1.2).timeout

	if _ui_root != null:
		_ui_root.queue_free()

	return {"taken": true, "photo": "selfie_casal"}


func _build_camera_ui() -> void:
	_ui_root = Control.new()
	_ui_root.custom_minimum_size = Vector2(320, 180)
	_ui_root.size = Vector2(320, 180)
	layer.add_child(_ui_root)

	# Fundo translúcido da câmera
	var viewfinder := Control.new()
	viewfinder.name = "Viewfinder"
	viewfinder.size = Vector2(320, 180)
	_ui_root.add_child(viewfinder)

	# Cantoneiras de enquadramento da câmera
	var corners := _create_viewfinder_corners()
	viewfinder.add_child(corners)

	# Retículo central de foco
	var reticle := Control.new()
	reticle.name = "Reticle"
	reticle.position = Vector2(160, 90)
	viewfinder.add_child(reticle)

	var box := ReferenceRect.new()
	box.size = Vector2(40, 40)
	box.position = Vector2(-20, -20)
	box.border_color = Color(1.0, 0.9, 0.2, 0.8)
	box.border_width = 1.0
	box.editor_only = false
	reticle.add_child(box)

	var dot := ColorRect.new()
	dot.size = Vector2(4, 4)
	dot.position = Vector2(-2, -2)
	dot.color = Color(1.0, 0.8, 0.2)
	reticle.add_child(dot)

	# Ícones superiores de câmera
	var top_bar := Label.new()
	top_bar.text = "● REC   [HDR]   ⚡ AUTO   100%"
	top_bar.position = Vector2(10, 6)
	top_bar.size = Vector2(300, 14)
	top_bar.add_theme_font_size_override("font_size", 10)
	top_bar.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 0.85))
	viewfinder.add_child(top_bar)

	# Botão de captura na parte inferior
	var hint := Label.new()
	hint.name = "HintLabel"
	hint.text = "📸 [Espaço / Clique] Tirar Foto!"
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	hint.position = Vector2(0, 154)
	hint.size = Vector2(320, 16)
	hint.add_theme_font_size_override("font_size", 12)
	hint.add_theme_color_override("font_color", Color(1.0, 0.9, 0.3))
	viewfinder.add_child(hint)


func _create_viewfinder_corners() -> Control:
	var c := Control.new()
	var col := Color(1.0, 1.0, 1.0, 0.75)
	var w := 12.0

	# Top-left
	c.add_child(_make_line(Vector2(20, 20), Vector2(20 + w, 20), col))
	c.add_child(_make_line(Vector2(20, 20), Vector2(20, 20 + w), col))

	# Top-right
	c.add_child(_make_line(Vector2(300, 20), Vector2(300 - w, 20), col))
	c.add_child(_make_line(Vector2(300, 20), Vector2(300, 20 + w), col))

	# Bottom-left
	c.add_child(_make_line(Vector2(20, 150), Vector2(20 + w, 150), col))
	c.add_child(_make_line(Vector2(20, 150), Vector2(20, 150 - w), col))

	# Bottom-right
	c.add_child(_make_line(Vector2(300, 150), Vector2(300 - w, 150), col))
	c.add_child(_make_line(Vector2(300, 150), Vector2(300, 150 - w), col))

	return c


func _make_line(from: Vector2, to: Vector2, color: Color) -> Line2D:
	var l := Line2D.new()
	l.width = 1.0
	l.default_color = color
	l.add_point(from)
	l.add_point(to)
	return l


func _trigger_flash_and_photo() -> void:
	# Som de clique do obturador
	AudioManager.play_sfx("camera_shutter")

	# Flash branco na tela
	var flash := ColorRect.new()
	flash.color = Color.WHITE
	flash.size = Vector2(320, 180)
	flash.z_index = 50
	_ui_root.add_child(flash)

	var f_tw := create_tween()
	f_tw.tween_property(flash, "modulate:a", 0.0, 0.35)
	await f_tw.finished
	flash.queue_free()

	# Esconde a mira
	var vf := _ui_root.get_node_or_null("Viewfinder")
	if vf != null:
		vf.visible = false

	# Exibe a foto Polaroid revelada no centro!
	var polaroid := TextureRect.new()
	polaroid.texture = load("res://assets/sprites/ui/selfie_casal.png")
	polaroid.position = Vector2(124, 48)
	polaroid.size = Vector2(72, 84)
	polaroid.scale = Vector2(0.3, 0.3)
	polaroid.pivot_offset = Vector2(36, 42)
	polaroid.rotation_degrees = -5.0
	_ui_root.add_child(polaroid)

	var p_tw := create_tween()
	p_tw.tween_property(polaroid, "scale", Vector2(1.25, 1.25), 0.5).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	p_tw.tween_property(polaroid, "scale", Vector2(1.15, 1.15), 0.2)
	await p_tw.finished

	# Efeito de coraçõezinhos saindo da foto
	AudioManager.play_sfx("kiss_chime", -4.0)
	var heart_tex: Texture2D = load("res://assets/sprites/ui/pixel_heart.png")
	for i in 4:
		var h := Sprite2D.new()
		h.texture = heart_tex
		h.position = polaroid.position + Vector2(randf_range(10, 60), randf_range(10, 40))
		h.scale = Vector2(0.5, 0.5)
		_ui_root.add_child(h)

		var h_tw := create_tween().set_parallel(true)
		h_tw.tween_property(h, "position:y", h.position.y - randf_range(20, 35), 1.2)
		h_tw.tween_property(h, "position:x", h.position.x + randf_range(-10, 10), 1.2)
		h_tw.tween_property(h, "scale", Vector2(1.0, 1.0), 0.4)
		h_tw.tween_property(h, "modulate:a", 0.0, 1.2)

	await get_tree().create_timer(1.8).timeout

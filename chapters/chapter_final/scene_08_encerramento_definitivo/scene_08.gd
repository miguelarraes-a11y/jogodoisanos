extends Node
## CAPÍTULO FINAL — CENA 08: ENCERRAMENTO DEFINITIVO
## O encerramento definitivo de todo o jogo.
## Miguel & Maria Fernanda ∞ com corações e estrelas discretas,
## seguido da declaração final: "Eu te amo para sempre, meu amor. ❤️".
## Fundo preto puro, letras brancas, sem datas, sem a palavra "FIM", sem menus.

var runner: CutsceneRunner
var overlay: CanvasLayer
var bg: ColorRect

# FontVariation para suportar os glifos de infinito (∞) e coração (❤️)
var font_with_fallback: FontVariation


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_final"
	GameState.scene_id = "scene_08"
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

	runner = CutsceneRunner.new()
	add_child(runner)

	_setup_font()
	_setup_canvas()
	_play()


func _setup_font() -> void:
	var sf := SystemFont.new()
	sf.font_names = PackedStringArray([
		"Segoe UI Emoji",
		"Segoe UI Symbol",
		"Apple Color Emoji",
		"Noto Color Emoji",
		"DejaVu Sans",
		"Arial"
	])
	var base_m5x7: Font = load("res://assets/fonts/m5x7.ttf")
	font_with_fallback = FontVariation.new()
	font_with_fallback.base_font = base_m5x7
	font_with_fallback.fallbacks = [sf]


func _setup_canvas() -> void:
	overlay = CanvasLayer.new()
	overlay.layer = 50
	add_child(overlay)

	bg = ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	overlay.add_child(bg)


func _play() -> void:
	# Garante que a música tema de amor continue tocando com suavidade serena
	if AudioManager.get("_music") == null:
		AudioManager.play_music("music_love_theme", 1.5, -4.0)

	# 1. Pequena pausa na escuridão total
	await runner.wait(1.5)

	# 2. Primeira Frase: "Miguel & Maria Fernanda ∞"
	var names_container := Control.new()
	names_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	names_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	names_container.modulate = Color(1.0, 1.0, 1.0, 0.0)
	overlay.add_child(names_container)

	var names_label := Label.new()
	names_label.text = "Miguel & Maria Fernanda ∞"
	names_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	names_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	names_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	names_label.add_theme_font_override("font", font_with_fallback)
	names_label.add_theme_font_size_override("font_size", 18)
	names_label.add_theme_color_override("font_color", Color.WHITE)
	names_container.add_child(names_label)

	# Pequenos corações e estrelas discretos ao redor dos nomes
	var ornaments := _create_discrete_ornaments()
	names_container.add_child(ornaments)

	# Animação delicada de entrada (Fade in)
	var tw_in1 := create_tween()
	tw_in1.tween_property(names_container, "modulate:a", 1.0, 2.0).set_trans(Tween.TRANS_SINE)
	await tw_in1.finished

	# Permanece por alguns segundos para contemplação
	await runner.wait(4.8)

	# O texto e os ornamentos desaparecem lentamente
	var tw_out1 := create_tween()
	tw_out1.tween_property(names_container, "modulate:a", 0.0, 1.8).set_trans(Tween.TRANS_SINE)
	await tw_out1.finished
	names_container.queue_free()

	# Tela preta novamente
	await runner.wait(1.5)

	# 3. A Última Mensagem: "Eu te amo para sempre, meu amor. ❤️"
	var final_label := Label.new()
	final_label.text = "Eu te amo para sempre, meu amor. ❤️"
	final_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	final_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	final_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	final_label.add_theme_font_override("font", font_with_fallback)
	final_label.add_theme_font_size_override("font_size", 15)
	final_label.add_theme_color_override("font_color", Color.WHITE)
	final_label.modulate = Color(1.0, 1.0, 1.0, 0.0)
	overlay.add_child(final_label)

	# Fade in delicado da declaração final
	var tw_in2 := create_tween()
	tw_in2.tween_property(final_label, "modulate:a", 1.0, 2.2).set_trans(Tween.TRANS_SINE)
	await tw_in2.finished

	# A mensagem permanece centralizada na tela
	await runner.wait(5.5)

	# A música termina suavemente (fade out de 4.5 segundos)
	AudioManager.stop_music(4.5)
	await runner.wait(4.0)

	# A tela escurece por completo
	var tw_out2 := create_tween()
	tw_out2.tween_property(final_label, "modulate:a", 0.0, 2.5).set_trans(Tween.TRANS_SINE)
	await tw_out2.finished
	final_label.queue_free()

	# Silêncio sereno definitivo
	await runner.wait(2.0)


func _create_discrete_ornaments() -> Node2D:
	var container := Node2D.new()
	container.position = Vector2(160, 90) # Centro da tela (320x180)

	var star_tex: Texture2D = load("res://assets/sprites/ui/pixel_star.png")
	var heart_tex: Texture2D = load("res://assets/sprites/ui/pixel_heart.png")

	# Posições relativas ao centro do texto "Miguel & Maria Fernanda ∞"
	var items: Array[Dictionary] = [
		{"tex": star_tex, "pos": Vector2(-118, -10), "scale": 0.85, "alpha": 0.75},
		{"tex": star_tex, "pos": Vector2(120, -10), "scale": 0.85, "alpha": 0.75},
		{"tex": heart_tex, "pos": Vector2(-102, 12), "scale": 0.9, "alpha": 0.80},
		{"tex": heart_tex, "pos": Vector2(104, 12), "scale": 0.9, "alpha": 0.80},
		{"tex": star_tex, "pos": Vector2(0, -22), "scale": 0.7, "alpha": 0.60}
	]

	for data in items:
		if data["tex"] == null:
			continue
		var sprite := Sprite2D.new()
		sprite.texture = data["tex"]
		sprite.position = data["pos"]
		sprite.scale = Vector2(data["scale"], data["scale"])
		sprite.modulate = Color(1.0, 1.0, 1.0, data["alpha"])
		container.add_child(sprite)

		# Animação suave e sutil de pulso/brilho
		var tw := sprite.create_tween().set_loops()
		tw.tween_property(sprite, "modulate:a", data["alpha"] * 0.45, 1.4).set_trans(Tween.TRANS_SINE)
		tw.tween_property(sprite, "modulate:a", data["alpha"], 1.4).set_trans(Tween.TRANS_SINE)

	return container

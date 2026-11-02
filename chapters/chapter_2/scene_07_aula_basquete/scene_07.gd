extends Node
## CAPÍTULO 2 — CENA 07: AULA DE BASQUETE & PULAR O PORTÃO DA QUADRA
## Ao chegarem na quadra coberta, encontram o portão trancado.
## Em um momento aventureiro e divertido, Miguel dá pezinho e os dois pulam o portão!
## Depois, Miguel ensina Maria Fernanda a postura e eles acertam a cesta juntos.
## No final, pulam o portão de volta para continuar o passeio.

const NEXT_SCENE := "res://chapters/chapter_2/scene_08_caminhada_avo/scene_08.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var court: BasketballCourt
var miguel: Character
var maria: Character
var ball: Ball
var gate: StaticBody2D


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_2"
	GameState.scene_id = "scene_07"

	runner = CutsceneRunner.new()
	add_child(runner)

	court = BasketballCourt.new()
	add_child(court)

	camera = FollowCamera.new()
	add_child(camera)
	camera.position = Vector2(160, 100)
	camera.make_current()

	_play()


func _play() -> void:
	AudioManager.play_music("music_first_date", 1.0, -4.0)

	# Portão de ferro na entrada da quadra (na parte inferior central)
	gate = PropFactory.make_prop(court.actors, "gate_iron", Vector2(160, 166))

	# Miguel e Maria chegam do lado de fora do portão (y = 176)
	miguel = Character.new()
	miguel.character_id = "miguel_encontro"
	miguel.position = Vector2(148, 176)
	court.actors.add_child(miguel)
	runner.face(miguel, "up")

	maria = Character.new()
	maria.character_id = "maria_encontro"
	maria.position = Vector2(164, 176)
	court.actors.add_child(maria)
	runner.face(maria, "up")

	# Bola de basquete posicionada dentro da quadra
	ball = Ball.new()
	court.actors.add_child(ball)
	ball.set_state(Vector2(180, 138), 0.0)

	await runner.fade_from_black(1.0)
	await runner.wait(0.5)

	# 1. Encontram o portão fechado
	await runner.say(["c2_s7_chegada"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_portao_fechado"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_maria_e_agora"])
	await runner.wait(0.4)

	# Miguel decide que vão pular o portão
	runner.face(miguel, "right")
	runner.face(maria, "left")
	await runner.say(["c2_s7_miguel_pular"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_maria_duvida"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_miguel_pezinho"])
	await runner.wait(0.5)

	# 2. Miguel ajuda Maria a pular o portão
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await _jump_character(maria, Vector2(164, 150))
	AudioManager.play_sfx("ball_bounce")
	runner.face(maria, "down")
	await runner.wait(0.4)

	await runner.say(["c2_s7_pularam_sucesso"])
	await runner.wait(0.3)

	# Miguel pula logo em seguida
	await _jump_character(miguel, Vector2(148, 150))
	AudioManager.play_sfx("ball_bounce")
	runner.face(miguel, "down")
	await runner.wait(0.3)

	await runner.say(["c2_s7_miguel_valeu"])
	await runner.wait(0.5)

	# 3. Caminham até o centro da quadra perto do aro
	runner.face(miguel, "up")
	runner.face(maria, "up")
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(148, 138)),
		runner.walk_to.bind(maria, Vector2(164, 138))
	])
	ball.set_state(Vector2(156, 138), 0.0)
	await runner.wait(0.4)

	# Miguel pega a bola e ensina a postura
	runner.face(miguel, "right")
	runner.face(maria, "left")
	await runner.say(["c2_s7_explicacao_1"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_maria_nervosa"])
	await runner.wait(0.3)

	# Miguel se posiciona carinhosamente junto a Maria
	await runner.walk_to(miguel, Vector2(160, 142))
	runner.face(miguel, "up")
	runner.face(maria, "up")
	ball.set_state(Vector2(162, 132), 14.0)
	await runner.wait(0.5)

	await runner.say(["c2_s7_ensino_proximo"])
	await runner.wait(0.4)

	# 4. Arremesso interativo em conjunto
	await _interactive_shot()

	# Cesta convertida e comemoração
	AudioManager.play_sfx("swish")
	await runner.wait(0.4)

	var orig_y := maria.position.y
	for j in 3:
		var jump := create_tween()
		jump.tween_property(maria, "position:y", orig_y - 6, 0.15)
		jump.tween_property(maria, "position:y", orig_y, 0.15)
		await jump.finished

	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.say(["c2_s7_arremesso_acertou"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_comemoracao"])
	await runner.wait(0.8)

	# 5. Hora de pular o portão de volta para ir embora
	await runner.parallel([
		runner.walk_to.bind(miguel, Vector2(148, 150)),
		runner.walk_to.bind(maria, Vector2(164, 150))
	])
	runner.face(miguel, "right")
	runner.face(maria, "left")

	await runner.say(["c2_s7_pular_saida"])
	await runner.wait(0.3)
	await runner.say(["c2_s7_maria_saida"])
	await runner.wait(0.5)

	# Miguel pula primeiro para fora
	await _jump_character(miguel, Vector2(148, 176))
	AudioManager.play_sfx("ball_bounce")
	runner.face(miguel, "up")
	await runner.wait(0.3)

	# Maria pula para fora nos braços de Miguel
	await _jump_character(maria, Vector2(164, 176))
	AudioManager.play_sfx("ball_bounce")
	runner.face(maria, "left")
	runner.face(miguel, "right")
	await runner.wait(1.0)

	await runner.fade_black(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.3)


func _jump_character(c: Character, to_pos: Vector2) -> void:
	AudioManager.play_sfx("throw")
	var start_pos := c.position
	var t := create_tween().set_parallel(true)
	t.tween_property(c, "position:x", to_pos.x, 0.45)
	
	# Efeito de pulo parabólico
	var ty := create_tween()
	ty.tween_property(c, "position:y", (start_pos.y + to_pos.y) / 2.0 - 18.0, 0.22).set_ease(Tween.EASE_OUT)
	ty.tween_property(c, "position:y", to_pos.y, 0.23).set_ease(Tween.EASE_IN)
	await ty.finished


func _interactive_shot() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 20
	add_child(layer)

	var panel := Panel.new()
	panel.size = Vector2(200, 44)
	panel.position = Vector2(60, 125)
	panel.add_theme_stylebox_override("panel", UiStyle.box())
	layer.add_child(panel)

	var title := UiStyle.make_label("ARREMESSEM JUNTOS!", 12, Color(0.9, 0.85, 0.3))
	title.position = Vector2(0, 4)
	title.size = Vector2(200, 14)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(title)

	var bar_bg := ColorRect.new()
	bar_bg.color = Color(0.15, 0.15, 0.2)
	bar_bg.position = Vector2(20, 22)
	bar_bg.size = Vector2(160, 8)
	panel.add_child(bar_bg)

	var green_zone := ColorRect.new()
	green_zone.color = Color(0.2, 0.8, 0.3, 0.8)
	green_zone.position = Vector2(60, 22)
	green_zone.size = Vector2(40, 8)
	panel.add_child(green_zone)

	var indicator := ColorRect.new()
	indicator.color = Color.YELLOW
	indicator.position = Vector2(20, 20)
	indicator.size = Vector2(4, 12)
	panel.add_child(indicator)

	var hint := UiStyle.make_label("[Espaço / Clique] Arremessar!", 10, UiStyle.BORDER)
	hint.position = Vector2(0, 32)
	hint.size = Vector2(200, 10)
	hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(hint)

	var t: float = 0.0
	var shot_fired := false

	while not shot_fired:
		t += get_process_delta_time() * 3.0
		var pos_x: float = 20.0 + (sin(t) * 0.5 + 0.5) * 156.0
		indicator.position.x = pos_x

		if Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			shot_fired = true

		await get_tree().process_frame

	layer.queue_free()

	# Executa o arremesso da bola em arco
	AudioManager.play_sfx("throw")
	var start_plan: Vector2 = ball.position
	var end_plan: Vector2 = court.hoop_plan
	var total_time: float = 1.0
	var elapsed: float = 0.0

	while elapsed < total_time:
		elapsed += get_process_delta_time()
		var p: float = clampf(elapsed / total_time, 0.0, 1.0)
		var current_plan: Vector2 = start_plan.lerp(end_plan, p)
		var current_z: float = 14.0 + sin(p * PI) * 55.0
		ball.set_state(current_plan, current_z)
		await get_tree().process_frame

	ball.z_index = 1
	AudioManager.play_sfx("ball_bounce")
	var bounce_time: float = 0.4
	var b_elapsed: float = 0.0
	while b_elapsed < bounce_time:
		b_elapsed += get_process_delta_time()
		var bp: float = clampf(b_elapsed / bounce_time, 0.0, 1.0)
		var bz: float = (1.0 - bp) * 34.0
		ball.set_state(end_plan + Vector2(0, bp * 10), bz)
		await get_tree().process_frame

	ball.set_state(end_plan + Vector2(0, 10), 0.0)

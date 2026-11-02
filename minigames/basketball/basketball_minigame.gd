class_name BasketballMinigame
extends MiniGameBase
## Minigame de basquete. Miguel arremessa de posições diferentes (config "spots").
##  1) A/D (ou setas) ajustam a direção. 2) Espaço inicia o arremesso: a barra de força oscila e o
##  marcador mostra onde a bola cairia. 3) Espaço de novo confirma. Cesta = bola cai dentro do círculo.
## Não exige vitória: depois dos arremessos a história segue sempre.
## Tudo configurável em data/minigames/basketball.json.

var court: BasketballCourt
var walker: Character          ## Miguel andando
var runner: CutsceneRunner
var shooter: Sprite2D          ## poses: 0 segurando, 1 preparando, 2 arremessando
var ball: Ball
var aim_view: AimIndicator

var score: int = 0
var baskets: int = 0
var shots_left: int = 0
var rest_pos: Vector2 = Vector2.ZERO
var aim: float = 0.0

var _phase: String = "idle"
var _power: float = 0.0
var _power_t: float = 0.0
var _spot: Vector2 = Vector2.ZERO
var _last_hop: int = 0
var _score_label: Label
var _shots_label: Label
var _bar: Control
var _bar_fill: ColorRect
var _bar_zone: ColorRect
var _bar_marker: ColorRect

const BAR_W := 100.0


func setup(p_court: BasketballCourt, p_walker: Character, p_runner: CutsceneRunner) -> void:
	court = p_court
	walker = p_walker
	runner = p_runner


func get_spot(i: int) -> Vector2:
	var spots: Array = config["spots"]
	var p: Array = spots[i % spots.size()]
	return Vector2(p[0], p[1])


# ---------- textos ----------
func _intro() -> Dictionary:
	return {
		"title": "BASQUETE",
		"lines": [
			"%s / %s : ajustar a direção" % [InputConfig.label_for("aim_left"), InputConfig.label_for("aim_right")],
			"%s : iniciar o arremesso e confirmar a força" % InputConfig.label_for("shoot"),
			"Solte quando o marcador dourado estiver",
			"dentro do círculo verde, sob a cesta.",
			"%d arremessos  •  %d pontos por cesta" % [int(cfg("shots", 5)), int(cfg("points_per_basket", 10))],
		],
		"hint": "[%s] começar" % InputConfig.label_for("confirm"),
	}


func _results(result: Dictionary) -> Dictionary:
	return {
		"title": "FIM DOS ARREMESSOS",
		"lines": ["Cestas: %d de %d" % [result["baskets"], result["shots"]], "Pontos: %d" % result["score"]],
		"hint": "[%s] continuar" % InputConfig.label_for("confirm"),
	}


# ---------- jogo ----------
func _play() -> Dictionary:
	_build_actors()
	_build_hud()
	var total := int(cfg("shots", 5))
	shots_left = total
	_update_hud()
	await get_tree().process_frame
	for i in total:
		_spot = get_spot(i)
		await _do_shot()
		if i < total - 1:
			await collect_ball()
			await runner.walk_to(walker, get_spot(i + 1), true)
			runner.face(walker, "up")
	_phase = "idle"
	_set_pose_mode(false)
	return {"score": score, "baskets": baskets, "shots": total}


func _build_actors() -> void:
	shooter = Sprite2D.new()
	shooter.texture = load("res://assets/sprites/characters/miguel_shoot.png")
	shooter.hframes = 3
	shooter.centered = false
	shooter.offset = Vector2(-8, -24)
	shooter.visible = false
	court.actors.add_child(shooter)
	ball = Ball.new()
	ball.visible = false
	court.actors.add_child(ball)
	aim_view = AimIndicator.new()
	court.markers.add_child(aim_view)


func _build_hud() -> void:
	_score_label = UiStyle.hud_label("PONTOS  00")
	_score_label.position = Vector2(6, 4)
	layer.add_child(_score_label)
	_shots_label = UiStyle.hud_label("ARREMESSOS  5")
	_shots_label.position = Vector2(232, 4)
	layer.add_child(_shots_label)
	_bar = Control.new()
	_bar.position = Vector2(110, 160)
	_bar.visible = false
	layer.add_child(_bar)
	var bg := Panel.new()
	bg.size = Vector2(BAR_W + 4, 10)
	bg.position = Vector2(-2, 0)
	bg.add_theme_stylebox_override("panel", UiStyle.box(Color(0.12, 0.09, 0.07, 0.85), UiStyle.BORDER, 2, 1))
	_bar.add_child(bg)
	_bar_zone = ColorRect.new()
	_bar_zone.color = Color(0.45, 0.9, 0.5, 0.55)
	_bar_zone.position = Vector2(0, 2)
	_bar_zone.size = Vector2(0, 6)
	_bar.add_child(_bar_zone)
	_bar_fill = ColorRect.new()
	_bar_fill.color = Color(1.0, 0.85, 0.3, 0.9)
	_bar_fill.position = Vector2(0, 4)
	_bar_fill.size = Vector2(0, 2)
	_bar.add_child(_bar_fill)
	_bar_marker = ColorRect.new()
	_bar_marker.color = Color.WHITE
	_bar_marker.position = Vector2(0, 1)
	_bar_marker.size = Vector2(2, 8)
	_bar.add_child(_bar_marker)
	var cap := UiStyle.hud_label("FORÇA", 7)
	cap.position = Vector2(0, -10)
	_bar.add_child(cap)


func _update_hud() -> void:
	_score_label.text = "PONTOS  %02d" % score
	_shots_label.text = "ARREMESSOS  %d" % shots_left


func _set_pose_mode(on: bool) -> void:
	shooter.visible = on
	walker.visible = not on
	if on:
		shooter.position = _spot
		walker.position = _spot
	else:
		walker.position = shooter.position


func _swap_walker(sheet_id: String) -> void:
	walker.character_id = sheet_id
	walker.sprite.sprite_frames = CharacterSprites.build(sheet_id)


func _process(delta: float) -> void:
	if _phase == "aim" or _phase == "power":
		var axis := Input.get_axis("aim_left", "aim_right")
		aim = clampf(aim + axis * cfg("aim_speed", 0.9) * delta, -cfg("aim_limit", 0.7), cfg("aim_limit", 0.7))
	if _phase == "power":
		_power_t += delta
		_power = pingpong(_power_t * cfg("power_speed", 1.1), 1.0)
		_bar_fill.size.x = BAR_W * _power
		_bar_marker.position.x = BAR_W * _power - 1.0
	if aim_view != null:
		aim_view.visible = (_phase == "aim" or _phase == "power")
		aim_view.set_state(_spot, aim, cfg("max_range", 130.0), _power if _phase == "power" else -1.0,
			court.hoop_plan, cfg("basket_radius", 9.0))


func _do_shot() -> void:
	_set_pose_mode(true)
	shooter.frame = 0
	aim = 0.0
	_power = 0.0
	_power_t = 0.0
	_bar_fill.size.x = 0.0
	_bar_marker.position.x = -1.0
	_setup_hint_zone()
	_bar.visible = true
	_phase = "aim"
	await wait_action("shoot")                # 1º Espaço: iniciar
	_phase = "power"
	shooter.frame = 1                          # preparando o arremesso
	await get_tree().process_frame
	await wait_action("shoot")                # 2º Espaço: confirmar a força
	var p := _power
	_phase = "flight"
	_bar.visible = false
	shooter.frame = 2                          # arremessando
	shots_left -= 1
	_update_hud()
	await _flight(p)


func _setup_hint_zone() -> void:
	if not config.get("show_power_hint", true):
		_bar_zone.size.x = 0.0
		return
	var p_star := _spot.distance_to(court.hoop_plan) / cfg("max_range", 130.0)
	var tol := cfg("basket_radius", 9.0) / cfg("max_range", 130.0)
	_bar_zone.position.x = BAR_W * (p_star - tol)
	_bar_zone.size.x = BAR_W * 2.0 * tol


func _flight(p: float) -> void:
	var hoop := court.hoop_plan
	var radius := cfg("basket_radius", 9.0)
	var rim_h := cfg("rim_height", 34.0)
	var dir := Vector2(sin(aim), -cos(aim))
	var land := _spot + dir * p * cfg("max_range", 130.0)
	land.y = maxf(land.y, 62.0) # bate na parede de fundo
	var dist := land.distance_to(hoop)
	var success := dist <= radius
	var near := dist <= radius * 2.4
	var target := hoop if success else land
	var end_z := rim_h if near else 0.0
	var z0 := 18.0

	ball.visible = true
	ball.set_state(_spot, z0)
	AudioManager.play_sfx("throw", -6.0)
	var t := create_tween()
	t.tween_method(_flight_step.bind(_spot, target, z0, end_z), 0.0, 1.0, cfg("flight_time", 1.0))
	await t.finished

	_last_hop = 0
	if success:
		score += int(cfg("points_per_basket", 10))
		baskets += 1
		_update_hud()
		AudioManager.play_sfx("swish", -2.0)
		court.swish_net()
		rest_pos = hoop + Vector2(randf_range(-12.0, 12.0), 18.0)
		await _bounce(hoop, rest_pos, rim_h, 1.2, 4)
	elif near:
		AudioManager.play_sfx("rim_clank", -4.0)
		var away := (land - hoop).normalized()
		if away == Vector2.ZERO:
			away = Vector2(0, 1)
		rest_pos = land + away * 26.0
		await _bounce(land, rest_pos, rim_h, 1.2, 4)
	else:
		var fwd := (land - _spot).normalized()
		rest_pos = land + fwd * 20.0
		await _bounce(land, rest_pos, 0.0, 1.0, 3)
	rest_pos = Vector2(clampf(rest_pos.x, 24.0, 296.0), clampf(rest_pos.y, 68.0, 172.0))
	ball.set_state(rest_pos, 0.0)
	await runner.wait(0.5)


func _flight_step(u: float, from: Vector2, to: Vector2, z0: float, end_z: float) -> void:
	var z := z0 + (end_z - z0) * u + cfg("arc_height", 40.0) * 4.0 * u * (1.0 - u)
	ball.set_state(from.lerp(to, u), z)


func _bounce(from: Vector2, to: Vector2, from_z: float, duration: float, hops: int) -> void:
	var t := create_tween()
	t.tween_method(_bounce_step.bind(from, to, from_z, hops), 0.0, 1.0, duration)
	await t.finished


func _bounce_step(u: float, from: Vector2, to: Vector2, from_z: float, hops: int) -> void:
	var phase := minf(u, 0.9999) * hops
	var hop := int(phase)
	var frac := phase - hop
	var z := 0.0
	if hop == 0 and from_z >= 1.0:
		z = from_z * (1.0 - frac * frac)            # queda da altura da cesta
	else:
		z = 9.0 * pow(0.45, maxi(hop - 1, 0)) * 4.0 * frac * (1.0 - frac)
	if hop != _last_hop:
		_last_hop = hop
		AudioManager.play_sfx("ball_bounce", -8.0 - 3.0 * hop)
	ball.set_state(from.lerp(to, u), z)


## Miguel vai até a bola, pega e fica segurando-a. Chamado entre os arremessos e no final da cena.
func collect_ball() -> void:
	_set_pose_mode(false)
	_swap_walker("miguel")
	await runner.walk_to(walker, rest_pos + Vector2(0, 6), true)
	ball.visible = false
	AudioManager.play_sfx("ball_bounce", -8.0)
	_swap_walker("miguel_ball")
	runner.face(walker, "up")
	await runner.wait(0.3)

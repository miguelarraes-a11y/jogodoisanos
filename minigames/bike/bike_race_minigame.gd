class_name BikeRaceMinigame
extends Node2D
## Minigame da Corrida de Bicicleta no Parque de Exposições de Itaipava.
## Disputa amigável entre Miguel e Maria Fernanda com contagem regressiva,
## HUD com cronômetro, barra de progresso, posição (1º/2º) e tela de resultado.

signal race_finished(winner_name: String)

var player_bike: BikeController
var maria_bike: BikeController

var waypoints: Array[Vector2] = []
var race_started: bool = false
var race_over: bool = false
var elapsed_time: float = 0.0
var winner: String = ""

var hud_layer: CanvasLayer
var countdown_lbl: Label
var timer_lbl: Label
var position_lbl: Label
var progress_bar: ProgressBar
var result_lbl: Label
var winner_banner: PanelContainer


func setup_racers(player: BikeController, rival: BikeController, circuit_waypoints: Array[Vector2]) -> void:
	player_bike = player
	maria_bike = rival
	waypoints = circuit_waypoints

	maria_bike.waypoints = waypoints
	maria_bike.controls_enabled = false
	player_bike.controls_enabled = false

	_create_hud()


func _create_hud() -> void:
	hud_layer = CanvasLayer.new()
	hud_layer.layer = 12
	add_child(hud_layer)

	# Painel superior com cronômetro e posição
	var top_panel := PanelContainer.new()
	top_panel.set_anchors_preset(Control.PRESET_TOP_WIDE)
	top_panel.offset_left = 10
	top_panel.offset_right = -10
	top_panel.offset_top = 6
	top_panel.offset_bottom = 26
	var top_style := StyleBoxFlat.new()
	top_style.bg_color = Color(0.1, 0.12, 0.16, 0.75)
	top_style.set_corner_radius_all(4)
	top_panel.add_theme_stylebox_override("panel", top_style)
	hud_layer.add_child(top_panel)

	var hbox := HBoxContainer.new()
	hbox.alignment = BoxContainer.ALIGNMENT_CENTER
	top_panel.add_child(hbox)

	position_lbl = Label.new()
	position_lbl.text = "Posição: 1º"
	position_lbl.add_theme_font_size_override("font_size", 11)
	position_lbl.add_theme_color_override("font_color", Color("ffd166"))
	hbox.add_child(position_lbl)

	var sep1 := VSeparator.new()
	hbox.add_child(sep1)

	timer_lbl = Label.new()
	timer_lbl.text = "Tempo: 00:00.0"
	timer_lbl.add_theme_font_size_override("font_size", 11)
	timer_lbl.add_theme_color_override("font_color", Color.WHITE)
	hbox.add_child(timer_lbl)

	var sep2 := VSeparator.new()
	hbox.add_child(sep2)

	var hint_lbl := Label.new()
	hint_lbl.text = "[W/A/S/D] Guiar | [Espaço] Impulso"
	hint_lbl.add_theme_font_size_override("font_size", 9)
	hint_lbl.add_theme_color_override("font_color", Color("a8dadc"))
	hbox.add_child(hint_lbl)

	# Barra de progresso do percurso
	progress_bar = ProgressBar.new()
	progress_bar.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	progress_bar.offset_left = 30
	progress_bar.offset_right = -30
	progress_bar.offset_top = -14
	progress_bar.offset_bottom = -6
	progress_bar.max_value = 100.0
	progress_bar.value = 0.0
	progress_bar.show_percentage = false
	var bar_style := StyleBoxFlat.new()
	bar_style.bg_color = Color(0.18, 0.75, 0.45)
	bar_style.set_corner_radius_all(3)
	progress_bar.add_theme_stylebox_override("fill", bar_style)
	hud_layer.add_child(progress_bar)

	# Label de contagem regressiva central
	countdown_lbl = Label.new()
	countdown_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	countdown_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	countdown_lbl.set_anchors_preset(Control.PRESET_FULL_RECT)
	countdown_lbl.add_theme_font_size_override("font_size", 28)
	countdown_lbl.add_theme_color_override("font_color", Color("f4ea8a"))
	hud_layer.add_child(countdown_lbl)


func start_countdown() -> void:
	AudioManager.play_sfx("race_beep", 0.0)
	countdown_lbl.text = "3..."
	await get_tree().create_timer(0.9).timeout

	AudioManager.play_sfx("race_beep", 0.0)
	countdown_lbl.text = "2..."
	await get_tree().create_timer(0.9).timeout

	AudioManager.play_sfx("race_beep", 0.0)
	countdown_lbl.text = "1..."
	await get_tree().create_timer(0.9).timeout

	AudioManager.play_sfx("race_go", 2.0)
	countdown_lbl.text = "JÁ!"
	countdown_lbl.add_theme_color_override("font_color", Color("06d6a0"))

	race_started = true
	player_bike.controls_enabled = true
	maria_bike.controls_enabled = true
	AudioManager.play_music("music_bike_race", 0.5, -2.0)

	await get_tree().create_timer(0.7).timeout
	countdown_lbl.visible = false


func _process(delta: float) -> void:
	if not race_started or race_over:
		return

	elapsed_time += delta
	var minutes := int(elapsed_time) / 60
	var seconds := int(elapsed_time) % 60
	var tenths := int((elapsed_time - int(elapsed_time)) * 10)
	timer_lbl.text = "Tempo: %02d:%02d.%d" % [minutes, seconds, tenths]

	# Cálculo de progresso e posição baseado no último waypoint
	var finish_pos: Vector2 = waypoints.back() if not waypoints.is_empty() else Vector2.ZERO
	var start_pos: Vector2 = waypoints.front() if not waypoints.is_empty() else Vector2.ZERO
	var total_dist := start_pos.distance_to(finish_pos) + 0.01

	var player_rem := player_bike.global_position.distance_to(finish_pos)
	var maria_rem := maria_bike.global_position.distance_to(finish_pos)

	var prog := clampf((1.0 - (player_rem / total_dist)) * 100.0, 0.0, 100.0)
	progress_bar.value = prog

	if player_rem <= maria_rem:
		position_lbl.text = "Posição: 1º"
		position_lbl.add_theme_color_override("font_color", Color("ffd166"))
	else:
		position_lbl.text = "Posição: 2º"
		position_lbl.add_theme_color_override("font_color", Color("ef476f"))

	# Verificação de chegada (a menos de 30px da linha de chegada)
	if player_rem < 35.0 and winner == "":
		_finish_race("Miguel")
	elif maria_rem < 30.0 and winner == "":
		_finish_race("Maria Fernanda")


func _finish_race(winner_name: String) -> void:
	race_over = true
	winner = winner_name

	AudioManager.play_sfx("race_go", 3.0)
	player_bike.controls_enabled = false
	maria_bike.controls_enabled = false

	# Banner de resultado
	winner_banner = PanelContainer.new()
	winner_banner.set_anchors_preset(Control.PRESET_CENTER)
	winner_banner.offset_left = -110
	winner_banner.offset_top = -26
	winner_banner.offset_right = 110
	winner_banner.offset_bottom = 26
	var b_style := StyleBoxFlat.new()
	b_style.bg_color = Color(0.08, 0.10, 0.14, 0.90)
	b_style.border_color = Color("ffd166") if winner_name == "Miguel" else Color("06d6a0")
	b_style.set_border_width_all(2)
	b_style.set_corner_radius_all(6)
	winner_banner.add_theme_stylebox_override("panel", b_style)
	hud_layer.add_child(winner_banner)

	result_lbl = Label.new()
	result_lbl.text = "%s Venceu!" % winner_name
	result_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	result_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	result_lbl.add_theme_font_size_override("font_size", 16)
	result_lbl.add_theme_color_override("font_color", Color("ffd166") if winner_name == "Miguel" else Color("06d6a0"))
	winner_banner.add_child(result_lbl)

	await get_tree().create_timer(3.0).timeout
	race_finished.emit(winner_name)

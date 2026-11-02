extends Node
## CENA 01 — UM DIA COMUM (27/09/2024). Cutscene cinematográfica, sem controle do jogador.
## Sequência: tela preta -> data -> despertador -> tela dividida -> os dois acordam ->
## começam suas rotinas -> a tela deixa de ser dividida e acompanha só o Miguel.
##
## PROVISÓRIO (marcado para troca): pijamas, cor dos cobertores, qual cama é a do Miguel,
## e a "rotina" de cada um (só andam um pouco; nada além do descrito foi inventado).

const CHAPTER_JSON := "res://chapters/prologue/chapter.json"
const NEXT_SCENE := "res://chapters/prologue/scene_02_manha_miguel/scene_02.tscn"
const DAWN := Color(0.55, 0.60, 0.82)
const MORNING := Color(1.0, 0.95, 0.86)

var runner: CutsceneRunner
var split: SplitScreen
var date_label: Label
var miguel_room: MiguelRoom
var maria_room: MariaRoom
var alarm_player: AudioStreamPlayer
var ambient_player: AudioStreamPlayer
var clock_tweens: Array = []
var miguel: Character
var maria: Character


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "prologue"
	GameState.scene_id = "scene_01"

	runner = CutsceneRunner.new()
	add_child(runner)

	split = SplitScreen.new()
	add_child(split)
	miguel_room = MiguelRoom.new()
	split.left_viewport.add_child(miguel_room)
	maria_room = MariaRoom.new()
	split.right_viewport.add_child(maria_room)
	split.left_camera.position = Vector2(80, 90)
	split.right_camera.position = Vector2(80, 90)
	miguel_room.light.color = DAWN
	maria_room.light.color = DAWN

	_build_date_label()
	_play()


func _build_date_label() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 3
	add_child(layer)
	date_label = Label.new()
	date_label.text = _read_date()
	date_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	date_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	date_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	date_label.add_theme_font_size_override("font_size", 20)
	date_label.add_theme_color_override("font_color", Color("f4ead2"))
	date_label.modulate.a = 0.0
	layer.add_child(date_label)


## Lê a data do chapter.json (2024-09-27) e mostra como 27/09/2024.
func _read_date() -> String:
	var f := FileAccess.open(CHAPTER_JSON, FileAccess.READ)
	var data: Variant = JSON.parse_string(f.get_as_text()) if f != null else null
	var iso := "2024-09-27"
	if typeof(data) == TYPE_DICTIONARY:
		iso = String(data.get("date", iso))
	var p := iso.split("-")
	return "%s/%s/%s" % [p[2], p[1], p[0]]


func _play() -> void:
	# 1-3) tela preta, data surge, fica alguns segundos
	await runner.wait(1.0)
	await runner.tween_prop(date_label, "modulate:a", 1.0, 2.0)
	await runner.wait(3.0)
	# 4) despertador começa a tocar (nos dois quartos); 5) data some aos poucos
	alarm_player = runner.sfx("alarm", -4.0, true)
	_shake_clocks(true)
	await runner.wait(1.0)
	ambient_player = runner.sfx("ambient_room", -20.0, true)
	await runner.tween_prop(date_label, "modulate:a", 0.0, 1.5)

	# 6-8) tela dividida: Miguel dormindo à esquerda, Maria Fernanda à direita
	await split.reveal(1.5)
	await runner.wait(0.8)
	maria_room.kovak.frame = 1 # Kovak só levanta a cabeça
	await runner.wait(1.2)

	# 9) os dois acordam, cada um no seu quarto
	miguel_room.sleeper.set_state(Sleeper.AWAKE)
	await runner.wait(0.4)
	maria_room.sleeper.set_state(Sleeper.AWAKE)
	await runner.wait(0.6)
	_shake_clocks(false)
	AudioManager.stop_player(alarm_player, 0.4)
	_fade_light_to_morning()
	runner.music("music_prologue", 3.0, -8.0)
	await runner.wait(1.2)
	miguel_room.sleeper.set_state(Sleeper.SIT)
	maria_room.sleeper.set_state(Sleeper.SIT)
	await runner.wait(1.4)

	# levantam da cama e 10) começam as rotinas (provisório)
	miguel_room.sleeper.hide()
	maria_room.sleeper.hide()
	miguel = miguel_room.spawn_standing("miguel_pijama", miguel_room.MIGUEL_BED + Vector2(0, 8))
	maria = maria_room.spawn_standing("maria_fernanda_pijama", maria_room.LADDER_EXIT)
	await runner.wait(0.5)
	await runner.parallel([_miguel_routine_a, _maria_routine])
	await runner.wait(0.5)
	await runner.say(["s1_miguel_acorda", "s1_maria_acorda"])
	await runner.wait(0.5)

	# transição: a tela deixa de ser dividida e passa a acompanhar só o Miguel
	await runner.parallel([_merge_screen, _miguel_routine_b])
	await runner.wait(2.0)

	# fim da cena: progresso salvo; a Cena 02 entra na Etapa 4
	AudioManager.stop_player(ambient_player, 1.5)
	await runner.fade_black(1.2)
	GameState.scene_id = "scene_02"
	GameState.save_game()
	SceneManager.change_scene(NEXT_SCENE, 0.3)


func _miguel_routine_a() -> void:
	await runner.walk_path(miguel, [miguel.position + Vector2(0, 8), Vector2(118, 122)])
	runner.face(miguel, "down")


func _maria_routine() -> void:
	await runner.walk_to(maria, Vector2(116, 66))
	runner.face(maria, "up")


func _merge_screen() -> void:
	await split.merge_to_left(2.2)


## Miguel segue pelo quarto (agora visível por inteiro) até o guarda-roupa.
func _miguel_routine_b() -> void:
	await runner.walk_to(miguel, Vector2(190, 70))
	runner.face(miguel, "up")


func _shake_clocks(on: bool) -> void:
	for t in clock_tweens:
		t.kill()
	clock_tweens.clear()
	for c in [miguel_room.clock, maria_room.clock]:
		c.position.x = 0.0
		if on:
			var t := create_tween().set_loops()
			t.tween_property(c, "position:x", 1.0, 0.04)
			t.tween_property(c, "position:x", -1.0, 0.04)
			clock_tweens.append(t)


func _fade_light_to_morning() -> void:
	for room in [miguel_room, maria_room]:
		var t := create_tween()
		t.tween_property(room.light, "color", MORNING, 2.5)

class_name CandyRunMinigame
extends MiniGameBase
## Minigame da Corrida dos Doces de São Cosme e Damião.
## Maria Fernanda percorre as ruas residenciais interagindo com moradores
## nas portas e portões para arrecadar saquinhos de doces,
## disputando amigavelmente com Ana Clara e Gabriele (IA).

var maria: Character
var ana: Character
var gabriele: Character
var spots: Array = []
var runner: CutsceneRunner

var ana_ai: FriendAI
var gabriele_ai: FriendAI

var maria_score: int = 0
var time_left: float = 60.0
var _is_running: bool = false

var _maria_label: Label
var _time_label: Label
var _friends_label: Label


func setup(p_maria: Character, p_ana: Character, p_gabriele: Character, p_spots: Array, p_runner: CutsceneRunner) -> void:
	maria = p_maria
	ana = p_ana
	gabriele = p_gabriele
	spots = p_spots
	runner = p_runner

	# Configura IAs das amigas
	ana_ai = FriendAI.new()
	add_child(ana_ai)
	ana_ai.setup(ana, "ana_clara", spots)
	ana_ai.score_changed.connect(_on_friend_score)

	gabriele_ai = FriendAI.new()
	add_child(gabriele_ai)
	gabriele_ai.setup(gabriele, "gabriele", spots)
	gabriele_ai.score_changed.connect(_on_friend_score)

	for s in spots:
		if s is CandySpot:
			s.candy_taken.connect(_on_spot_candy_taken)


func _intro() -> Dictionary:
	return {
		"title": "CORRIDA DOS DOCES (SÃO COSME E DAMIÃO)",
		"lines": [
			"Tradição de 27 de setembro pelas ruas do bairro.",
			"%s / Setas : movimentar Maria Fernanda" % InputConfig.label_for("move_left"),
			"%s : correr levemente" % InputConfig.label_for("run"),
			"%s : pegar saquinho com morador no portão" % InputConfig.label_for("interact"),
			"Tente pegar mais saquinhos que Ana Clara e Gabriele!",
			"Duração: %d segundos" % int(cfg("duration", 60.0)),
		],
		"hint": "[%s] começar" % InputConfig.label_for("confirm"),
	}


func _results(result: Dictionary) -> Dictionary:
	var mf: int = result.get("maria", 0)
	var ac: int = result.get("ana_clara", 0)
	var gb: int = result.get("gabriele", 0)

	var banner := ""
	if mf > ac and mf > gb:
		banner = "Maria Fernanda pegou mais saquinhos!"
	elif mf == ac or mf == gb:
		banner = "Empate amigável! Muitas guloseimas para dividir."
	else:
		banner = "Foi por pouco! O melhor foram as lembranças."

	return {
		"title": "FIM DA COLETA DE DOCES",
		"lines": [
			"Maria Fernanda: %02d saquinhos" % mf,
			"Ana Clara: %02d saquinhos" % ac,
			"Gabriele: %02d saquinhos" % gb,
			banner,
		],
		"hint": "[%s] continuar" % InputConfig.label_for("confirm"),
	}


func _play() -> Dictionary:
	time_left = cfg("duration", 60.0)
	maria_score = 0
	_build_hud()
	_update_hud()

	# Libera controle para Maria Fernanda
	maria.set_player(true)
	GameState.controls_locked = false
	_is_running = true

	while _is_running and time_left > 0.0:
		await get_tree().process_frame
		time_left -= get_process_delta_time()
		_update_hud()
		if not _any_candies_left():
			# Todos os doces do bairro foram recolhidos
			break

	_is_running = false
	GameState.controls_locked = true
	maria.set_player(false)
	ana_ai.stop()
	gabriele_ai.stop()

	await get_tree().create_timer(0.5).timeout

	return {
		"maria": maria_score,
		"ana_clara": ana_ai.score,
		"gabriele": gabriele_ai.score,
	}


func _build_hud() -> void:
	_maria_label = UiStyle.hud_label("Maria: 00", 9)
	_maria_label.position = Vector2(8, 4)
	layer.add_child(_maria_label)

	_time_label = UiStyle.hud_label("TEMPO  60", 9)
	_time_label.position = Vector2(130, 4)
	layer.add_child(_time_label)

	_friends_label = UiStyle.hud_label("Ana: 00  •  Gabi: 00", 8)
	_friends_label.position = Vector2(210, 4)
	layer.add_child(_friends_label)


func _update_hud() -> void:
	if _maria_label != null and is_instance_valid(_maria_label):
		_maria_label.text = "Maria: %02d" % maria_score
	if _time_label != null and is_instance_valid(_time_label):
		_time_label.text = "TEMPO  %02d" % maxi(0, int(time_left))
	if _friends_label != null and is_instance_valid(_friends_label):
		var ac: int = ana_ai.score if ana_ai != null else 0
		var gb: int = gabriele_ai.score if gabriele_ai != null else 0
		_friends_label.text = "Ana: %02d  •  Gabi: %02d" % [ac, gb]


func _on_spot_candy_taken(by_who: Character, _remaining: int) -> void:
	if by_who == maria:
		maria_score += 1
		AudioManager.play_sfx("candy_pickup", -2.0)
		_update_hud()
	else:
		AudioManager.play_sfx("candy_pickup", -9.0)


func _on_friend_score(_friend_id: String, _new_score: int) -> void:
	_update_hud()


func _any_candies_left() -> bool:
	for s in spots:
		if s is CandySpot and is_instance_valid(s) and s.has_candy():
			return true
	return false

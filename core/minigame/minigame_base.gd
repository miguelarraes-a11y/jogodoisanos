class_name MiniGameBase
extends Node
## Base de todos os minigames. Fluxo: instruções -> jogo -> resultados -> retorno à narrativa.
## Cada minigame filho implementa _play() e, se quiser, _intro() e _results().
## A configuração (número de tentativas, tempo, pontos...) vem de um JSON em data/minigames/.

signal finished(result: Dictionary)

var config: Dictionary = {}
var layer: CanvasLayer


func load_config(path: String) -> void:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Configuração do minigame não encontrada: " + path)
		return
	var data: Variant = JSON.parse_string(f.get_as_text())
	if typeof(data) == TYPE_DICTIONARY:
		config = data


func cfg(key: String, default: float = 0.0) -> float:
	return float(config.get(key, default))


func run() -> Dictionary:
	layer = CanvasLayer.new()
	layer.layer = 8
	add_child(layer)
	GameState.controls_locked = true
	var intro := _intro()
	if config.get("show_intro", true) and not intro.is_empty():
		await show_panel(intro["title"], intro["lines"], intro.get("hint", ""), "confirm")
		await get_tree().process_frame
	var result: Dictionary = await _play()
	var res := _results(result)
	if not res.is_empty():
		await show_panel(res["title"], res["lines"], res.get("hint", ""), "confirm", cfg("results_seconds", 0.0))
	layer.queue_free()
	finished.emit(result)
	return result


# --- para os filhos sobrescreverem ---
func _intro() -> Dictionary:
	return {}


func _play() -> Dictionary:
	return {}


func _results(_result: Dictionary) -> Dictionary:
	return {}


# --- utilitários ---
func wait_action(action: String) -> void:
	while not Input.is_action_just_pressed(action):
		await get_tree().process_frame


## Painel centralizado (instruções ou resultados). Fecha com a tecla da ação ou após auto_close segundos.
func show_panel(title: String, lines: Array, hint: String, action: String, auto_close: float = 0.0) -> void:
	var panel := Panel.new()
	panel.size = Vector2(260, 44 + 14 * lines.size() + (18 if hint != "" else 0))
	panel.position = (Vector2(320, 180) - panel.size) / 2.0
	panel.add_theme_stylebox_override("panel", UiStyle.box())
	var t := UiStyle.make_label(title, 15)
	t.position = Vector2(0, 6)
	t.size = Vector2(panel.size.x, 16)
	t.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	panel.add_child(t)
	var body := UiStyle.make_label("\n".join(PackedStringArray(lines)), 13)
	body.position = Vector2(10, 26)
	body.size = Vector2(panel.size.x - 20, 14.0 * lines.size())
	panel.add_child(body)
	if hint != "":
		var h := UiStyle.make_label(hint, 12, UiStyle.BORDER)
		h.position = Vector2(0, panel.size.y - 18)
		h.size = Vector2(panel.size.x, 14)
		h.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		panel.add_child(h)
	layer.add_child(panel)
	await get_tree().create_timer(0.3).timeout
	var elapsed := 0.0
	while not Input.is_action_just_pressed(action) and (auto_close <= 0.0 or elapsed < auto_close):
		await get_tree().process_frame
		elapsed += get_process_delta_time()
	panel.queue_free()

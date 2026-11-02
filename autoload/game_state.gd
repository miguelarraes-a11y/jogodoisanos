extends Node
## Estado global: progresso, flags da história e bloqueio de controles.

const SAVE_PATH := "user://save.json"

var chapter_id: String = "prologue"
var scene_id: String = "scene_01"
var flags: Dictionary = {}
## Quando true, o jogador não controla personagens (cutscenes, diálogos, transições).
var controls_locked: bool = false


func set_flag(key: String, value: Variant = true) -> void:
	flags[key] = value


func get_flag(key: String, default: Variant = false) -> Variant:
	return flags.get(key, default)


func save_game() -> void:
	var f := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if f == null:
		push_warning("Não foi possível salvar o progresso.")
		return
	f.store_string(JSON.stringify({"chapter": chapter_id, "scene": scene_id, "flags": flags}))


func has_save() -> bool:
	return FileAccess.file_exists(SAVE_PATH)


func load_game() -> bool:
	if not has_save():
		return false
	var f := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data: Variant = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		return false
	chapter_id = data.get("chapter", "prologue")
	scene_id = data.get("scene", "scene_01")
	flags = data.get("flags", {})
	return true

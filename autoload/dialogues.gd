extends Node
## Carrega as falas de data/dialogues/*.json. Nenhuma fala fica escrita no código.

const PATHS: Array[String] = [
	"res://data/dialogues/prologue.json",
	"res://data/dialogues/chapter_1.json",
	"res://data/dialogues/chapter_2.json",
	"res://data/dialogues/chapter_3.json",
	"res://data/dialogues/chapter_4.json",
	"res://data/dialogues/chapter_final.json",
]

var _entries: Dictionary = {}


func _ready() -> void:
	for path in PATHS:
		_load_file(path)


func _load_file(path: String) -> void:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		push_error("Arquivo de falas não encontrado: " + path)
		return
	var data: Variant = JSON.parse_string(f.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		push_error("JSON de falas inválido: " + path)
		return
	for section in data:
		if String(section).begins_with("_"):
			continue
		for entry in data[section]:
			_entries[entry["id"]] = entry


func get_line(id: String) -> Dictionary:
	return _entries.get(id, {"speaker": "", "text": "[FALA PENDENTE: %s]" % id})


func get_lines(ids: Array) -> Array:
	var out: Array = []
	for id in ids:
		out.append(get_line(String(id)))
	return out

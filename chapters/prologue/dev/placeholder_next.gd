extends Node
## Tela provisória: mostra qual é a próxima cena (ainda não criada).
## Enter volta para a Cena 01, para testar de novo.

const DEFAULT_RETRY := "res://chapters/prologue/scene_01_um_dia_comum/scene_01.tscn"

var _label: Label


func _ready() -> void:
	var layer := CanvasLayer.new()
	add_child(layer)
	_label = Label.new()
	_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 10)
	_label.add_theme_color_override("font_color", Color("f4ead2"))
	_label.text = "%s\n\nProgresso salvo.\nEnter: rever a cena anterior" % GameState.get_flag("next_label", "Próxima cena")
	layer.add_child(_label)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") or event.is_action_pressed("confirm"):
		SceneManager.change_scene(GameState.get_flag("retry_path", DEFAULT_RETRY))

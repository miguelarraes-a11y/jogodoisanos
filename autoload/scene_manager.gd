extends Node
## Troca de cenas com fade preto (base para as transições entre cenas do prólogo).

var _layer: CanvasLayer
var _rect: ColorRect
var _busy: bool = false


func _ready() -> void:
	_layer = CanvasLayer.new()
	_layer.layer = 100
	add_child(_layer)
	_rect = ColorRect.new()
	_rect.color = Color.BLACK
	_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_rect.modulate.a = 0.0
	_layer.add_child(_rect)


func fade_out(duration: float = 0.6) -> void:
	var t := create_tween()
	t.tween_property(_rect, "modulate:a", 1.0, duration)
	await t.finished


func fade_in(duration: float = 0.6) -> void:
	var t := create_tween()
	t.tween_property(_rect, "modulate:a", 0.0, duration)
	await t.finished


func change_scene(path: String, duration: float = 0.6) -> void:
	if _busy:
		return
	_busy = true
	GameState.controls_locked = true
	await fade_out(duration)
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame
	await fade_in(duration)
	GameState.controls_locked = false
	_busy = false

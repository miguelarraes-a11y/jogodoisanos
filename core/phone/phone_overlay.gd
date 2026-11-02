class_name PhoneOverlay
extends CanvasLayer
## Interface de celular simulada em pixel art (320x180).
## Exibe a carcaça do celular com animação de deslizar e hospeda aplicativos (Instagram, WhatsApp).

signal opened
signal closed

var backdrop: ColorRect
var phone_body: Panel
var screen_area: Control
var is_open: bool = false

const PHONE_SIZE := Vector2(136, 172)
const CLOSED_Y := 190.0
const OPEN_Y := 4.0


func _ready() -> void:
	layer = 12
	_build_ui()


func _build_ui() -> void:
	# Fundo escurecido suave
	backdrop = ColorRect.new()
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.color = Color(0, 0, 0, 0.45)
	backdrop.modulate.a = 0.0
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)

	# Corpo do celular
	phone_body = Panel.new()
	phone_body.size = PHONE_SIZE
	phone_body.position = Vector2((320.0 - PHONE_SIZE.x) / 2.0, CLOSED_Y)
	
	var style := StyleBoxFlat.new()
	style.bg_color = Color("1e1e24") # carcaça preta grafite
	style.border_color = Color("383842")
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	phone_body.add_theme_stylebox_override("panel", style)
	add_child(phone_body)

	# Alto-falante superior / notch
	var speaker := ColorRect.new()
	speaker.color = Color("3a3a44")
	speaker.position = Vector2((PHONE_SIZE.x - 24.0) / 2.0, 3)
	speaker.size = Vector2(24, 2)
	phone_body.add_child(speaker)

	# Área da tela do celular
	screen_area = Control.new()
	screen_area.position = Vector2(4, 7)
	screen_area.size = Vector2(PHONE_SIZE.x - 8.0, PHONE_SIZE.y - 14.0)
	screen_area.clip_contents = true
	phone_body.add_child(screen_area)

	# Barra inferior de navegação do celular
	var home_bar := ColorRect.new()
	home_bar.color = Color(1, 1, 1, 0.4)
	home_bar.position = Vector2((PHONE_SIZE.x - 30.0) / 2.0, PHONE_SIZE.y - 4)
	home_bar.size = Vector2(30, 2)
	phone_body.add_child(home_bar)


func open(app_node: Control) -> void:
	for child in screen_area.get_children():
		child.queue_free()
	app_node.size = screen_area.size
	screen_area.add_child(app_node)
	app_node.set_anchors_preset(Control.PRESET_FULL_RECT)

	is_open = true
	backdrop.mouse_filter = Control.MOUSE_FILTER_STOP
	var t := create_tween().set_parallel(true)
	t.tween_property(backdrop, "modulate:a", 1.0, 0.35)
	t.tween_property(phone_body, "position:y", OPEN_Y, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	await t.finished
	opened.emit()


func close() -> void:
	var t := create_tween().set_parallel(true)
	t.tween_property(backdrop, "modulate:a", 0.0, 0.3)
	t.tween_property(phone_body, "position:y", CLOSED_Y, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await t.finished
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	is_open = false
	closed.emit()

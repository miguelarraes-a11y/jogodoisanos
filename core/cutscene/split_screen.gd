class_name SplitScreen
extends CanvasLayer
## Tela dividida verticalmente em duas partes iguais (cada uma é um SubViewport com seu
## próprio mundo 2D e câmera). Monte um cenário dentro de left_viewport e outro em
## right_viewport. merge_to_left() funde a tela e passa a mostrar só o lado esquerdo.

const HALF_W := 160.0
const H := 180.0

var holder: Control
var left_container: SubViewportContainer
var right_container: SubViewportContainer
var left_viewport: SubViewport
var right_viewport: SubViewport
var left_camera: Camera2D
var right_camera: Camera2D
var divider: ColorRect
## Borda esquerda (no mundo do cenário da esquerda) que a câmera mantém ao expandir.
var left_edge: float = 0.0


func _ready() -> void:
	layer = 1
	holder = Control.new()
	holder.set_anchors_preset(Control.PRESET_FULL_RECT)
	holder.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.modulate.a = 0.0
	add_child(holder)

	var l := _make_half(Vector2(0, 0))
	left_container = l[0]; left_viewport = l[1]; left_camera = l[2]
	var r := _make_half(Vector2(HALF_W, 0))
	right_container = r[0]; right_viewport = r[1]; right_camera = r[2]

	divider = ColorRect.new()
	divider.color = Color("1b1410")
	divider.position = Vector2(HALF_W - 1, 0)
	divider.size = Vector2(2, H)
	divider.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(divider)


func _make_half(pos: Vector2) -> Array:
	var c := SubViewportContainer.new()
	c.stretch = true
	c.position = pos
	c.size = Vector2(HALF_W, H)
	c.mouse_filter = Control.MOUSE_FILTER_IGNORE
	holder.add_child(c)
	var vp := SubViewport.new()
	vp.size = Vector2i(int(HALF_W), int(H))
	vp.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	vp.snap_2d_transforms_to_pixel = true
	vp.gui_disable_input = true
	c.add_child(vp)
	var cam := Camera2D.new()
	vp.add_child(cam)
	cam.make_current()
	return [c, vp, cam]


func reveal(duration: float = 1.5) -> void:
	var t := create_tween()
	t.tween_property(holder, "modulate:a", 1.0, duration)
	await t.finished


func hide_all(duration: float = 1.0) -> void:
	var t := create_tween()
	t.tween_property(holder, "modulate:a", 0.0, duration)
	await t.finished


## A tela deixa de ser dividida: o lado direito sai e o esquerdo ocupa a tela inteira.
func merge_to_left(duration: float = 2.0) -> void:
	var t := create_tween()
	t.tween_method(_set_left_width, HALF_W, HALF_W * 2.0, duration) \
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	await t.finished
	right_container.visible = false
	divider.visible = false


func _set_left_width(w: float) -> void:
	left_container.size = Vector2(w, H)
	right_container.position.x = w
	divider.position.x = w - 1.0
	left_camera.position.x = left_edge + w / 2.0

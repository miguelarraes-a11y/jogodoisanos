class_name PropFactory
## Funções para montar cenários provisórios (sprites de assets/tiles/ + colisão).
## O ponto de origem de cada prop é a BASE do sprite (y-sort funciona sozinho).

const TILES := "res://assets/tiles/"


static func tex(tex_name: String) -> Texture2D:
	return load(TILES + tex_name + ".png")


static func make_prop(parent: Node, tex_name: String, pos: Vector2,
		collision_size: Vector2 = Vector2.ZERO) -> StaticBody2D:
	var body := StaticBody2D.new()
	body.position = pos
	var t := tex(tex_name)
	var sprite := Sprite2D.new()
	sprite.texture = t
	sprite.centered = false
	sprite.offset = Vector2(-t.get_width() / 2.0, -t.get_height())
	body.add_child(sprite)
	if collision_size != Vector2.ZERO:
		body.collision_layer = 1
		body.collision_mask = 0
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = collision_size
		shape.shape = rect
		shape.position = Vector2(0, -collision_size.y / 2.0)
		body.add_child(shape)
	else:
		body.collision_layer = 0
		body.collision_mask = 0
	parent.add_child(body)
	return body


static func make_ground(parent: Node, tex_name: String, rect: Rect2, z: int) -> void:
	var tr := TextureRect.new()
	tr.texture = tex(tex_name)
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_TILE
	tr.position = rect.position
	tr.size = rect.size
	tr.z_index = z
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(tr)


## Gradiente suave que sugere a inclinação da rua (a subida/descida real fica para a Etapa 6).
static func make_slope_shade(parent: Node, rect: Rect2, z: int) -> void:
	var g := Gradient.new()
	g.colors = PackedColorArray([Color(1, 1, 1, 0.10), Color(0, 0, 0, 0.14)])
	g.offsets = PackedFloat32Array([0.0, 1.0])
	var t := GradientTexture2D.new()
	t.gradient = g
	t.width = 4
	t.height = 48
	t.fill_from = Vector2(0, 0)
	t.fill_to = Vector2(0, 1)
	var tr := TextureRect.new()
	tr.texture = t
	tr.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	tr.stretch_mode = TextureRect.STRETCH_SCALE
	tr.position = rect.position
	tr.size = rect.size
	tr.z_index = z
	tr.mouse_filter = Control.MOUSE_FILTER_IGNORE
	parent.add_child(tr)


static func make_wire(parent: Node, a: Vector2, b: Vector2) -> void:
	var line := Line2D.new()
	line.width = 1.0
	line.default_color = Color(0.14, 0.14, 0.17)
	line.z_index = 50
	var steps := 8
	for i in steps + 1:
		var t := float(i) / steps
		line.add_point(a.lerp(b, t) + Vector2(0, sin(t * PI) * 4.0))
	parent.add_child(line)

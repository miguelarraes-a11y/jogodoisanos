class_name StreetBuilder
extends RefCounted
## Monta a rua residencial brasileira.
## Mundo de 480x640: rua asfaltada vertical no centro, calçadas dos dois lados,
## casas residenciais brasileiras sem cercas (frentes e quintais abertos),
## árvores e postes com fiação aérea.

const WORLD := Rect2i(0, 0, 480, 640)
const HOUSE_TEXTURES: Array[String] = ["house_amarela", "house_azul", "house_verde", "house_salmao", "house_branca"]


static func build(root: Node2D, world: Node2D) -> void:
	_build_ground(root)
	_build_bounds(root)
	for i in 4:
		var y0 := 70 + i * 150
		_build_side(world, y0, 180.0, 136.0, HOUSE_TEXTURES[i % 5], i)
		_build_side(world, y0, 300.0, 344.0, HOUSE_TEXTURES[(i + 2) % 5], i)
	_build_poles_and_wires(root, world)


static func _build_ground(root: Node2D) -> void:
	PropFactory.make_ground(root, "grass", Rect2(0, 0, 480, 640), -30)
	PropFactory.make_ground(root, "sidewalk", Rect2(184, 0, 16, 640), -29)
	PropFactory.make_ground(root, "sidewalk", Rect2(280, 0, 16, 640), -29)
	PropFactory.make_ground(root, "asphalt", Rect2(200, 0, 80, 640), -29)
	PropFactory.make_slope_shade(root, Rect2(184, 0, 112, 640), -28)


static func _build_bounds(root: Node2D) -> void:
	for r in [Rect2(-16, -16, 512, 16), Rect2(-16, 640, 512, 16), Rect2(-16, 0, 16, 640), Rect2(480, 0, 16, 640)]:
		var body := StaticBody2D.new()
		body.collision_layer = 1
		var shape := CollisionShape2D.new()
		var rect := RectangleShape2D.new()
		rect.size = r.size
		shape.shape = rect
		shape.position = r.get_center()
		body.add_child(shape)
		root.add_child(body)


static func _build_side(world: Node2D, y0: int, side_x: float, house_x: float, house_tex: String, idx: int) -> void:
	var left := side_x < 240.0
	# Casas posicionadas abertas para a rua, sem cercas ou muros frontais
	PropFactory.make_prop(world, house_tex, Vector2(house_x, y0 + 120), Vector2(64, 28))
	var tree_x := side_x - 34.0 if left else side_x + 30.0
	PropFactory.make_prop(world, "tree", Vector2(tree_x, y0 + 30), Vector2(6, 4))
	if idx % 2 == 1:
		var far_x := house_x - 52.0 if left else house_x + 52.0
		PropFactory.make_prop(world, "tree", Vector2(far_x, y0 + 130), Vector2(6, 4))


static func _build_poles_and_wires(root: Node2D, world: Node2D) -> void:
	var left_tops: Array = []
	var right_tops: Array = []
	for y in [40, 190, 340, 490, 620]:
		PropFactory.make_prop(world, "pole", Vector2(188, y), Vector2.ZERO)
		left_tops.append(Vector2(188, y - 44))
	for y in [115, 265, 415, 565]:
		PropFactory.make_prop(world, "pole", Vector2(292, y), Vector2.ZERO)
		right_tops.append(Vector2(292, y - 44))
	for i in left_tops.size() - 1:
		PropFactory.make_wire(root, left_tops[i], left_tops[i + 1])
	for i in right_tops.size() - 1:
		PropFactory.make_wire(root, right_tops[i], right_tops[i + 1])
	for i in right_tops.size():
		PropFactory.make_wire(root, right_tops[i], left_tops[i])

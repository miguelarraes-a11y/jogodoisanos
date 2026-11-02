class_name BasketballCourt
extends Node2D
## Quadra coberta (320x180, uma tela). Camadas: fundo, marcadores no chão, cesta (trás),
## atores (Miguel, bola), cesta (frente, com a rede), luz. A bola passa ENTRE as duas partes da cesta.

var hoop_plan: Vector2 = Vector2(160, 66) ## ponto no chão sob o aro
var markers: Node2D
var actors: Node2D
var hoop_front: Sprite2D


func _ready() -> void:
	var back := CourtArt.new()
	back.kind = "back"
	back.z_index = -10
	add_child(back)
	markers = Node2D.new()
	markers.z_index = -5
	add_child(markers)
	add_child(_hoop_sprite("hoop_back", 0))
	actors = Node2D.new()
	actors.y_sort_enabled = true
	actors.z_index = 1
	add_child(actors)
	hoop_front = _hoop_sprite("hoop_front", 2)
	add_child(hoop_front)
	var light := CourtArt.new()
	light.kind = "light"
	light.z_index = 10
	add_child(light)
	_add_dust_motes()


func _hoop_sprite(tex_name: String, z: int) -> Sprite2D:
	var s := Sprite2D.new()
	s.texture = load("res://assets/sprites/%s.png" % tex_name)
	s.centered = false
	s.offset = Vector2(-14, -48)
	s.position = hoop_plan
	s.z_index = z
	return s


## Poeirinha flutuando nos feixes de luz (efeito discreto).
func _add_dust_motes() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 7
	for i in 10:
		var m := ColorRect.new()
		m.size = Vector2(1, 1)
		m.color = Color(1, 1, 0.9, 0.45)
		m.position = Vector2(rng.randf_range(4, 90) if i % 2 == 0 else rng.randf_range(230, 316), rng.randf_range(40, 150))
		m.z_index = 11
		add_child(m)
		var t := create_tween().set_loops()
		var dy := rng.randf_range(6.0, 14.0)
		var dur := rng.randf_range(3.0, 5.0)
		t.tween_property(m, "position:y", m.position.y + dy, dur).set_trans(Tween.TRANS_SINE)
		t.tween_property(m, "position:y", m.position.y, dur).set_trans(Tween.TRANS_SINE)


## Pulso na rede quando a bola passa.
func swish_net() -> void:
	var t := create_tween()
	t.tween_property(hoop_front, "scale:x", 1.12, 0.07)
	t.tween_property(hoop_front, "scale:x", 1.0, 0.18)

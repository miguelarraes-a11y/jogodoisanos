class_name CourtArt
extends Node2D
## Desenho da quadra COBERTA, comum e levemente suja (provisório, tudo por código).
## kind "back": telhado com estrutura metálica, parede, piso de cimento, linhas, colunas.
## kind "light": feixes de luz natural entrando pelas laterais.

var kind: String = "back"


func _draw() -> void:
	if kind == "back":
		_draw_back()
	else:
		_draw_light()


func _draw_back() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 20240927
	# piso de cimento com juntas e manchas de uso
	draw_rect(Rect2(0, 58, 320, 122), Color8(176, 172, 162))
	for x in range(0, 321, 80):
		draw_line(Vector2(x, 58), Vector2(x, 180), Color8(152, 148, 140))
	for y in [118, 178]:
		draw_line(Vector2(0, y), Vector2(320, y), Color8(152, 148, 140))
	for i in 28:
		var r := Rect2(rng.randf_range(0, 300), rng.randf_range(62, 175), rng.randf_range(6, 22), rng.randf_range(2, 6))
		draw_rect(r, Color(0.35, 0.30, 0.25, rng.randf_range(0.05, 0.12)))
	# parede de fundo: pintura clara com faixa azul na parte de baixo
	draw_rect(Rect2(0, 12, 320, 46), Color8(216, 208, 186))
	draw_rect(Rect2(0, 38, 320, 20), Color8(72, 112, 160))
	draw_line(Vector2(0, 38), Vector2(320, 38), Color8(110, 150, 196))
	draw_line(Vector2(0, 58), Vector2(320, 58), Color8(110, 106, 98))
	for i in 14:
		var r := Rect2(rng.randf_range(0, 310), rng.randf_range(14, 36), rng.randf_range(3, 10), rng.randf_range(4, 14))
		draw_rect(r, Color(0.5, 0.42, 0.3, rng.randf_range(0.06, 0.12)))
	# telhado: estrutura metálica (treliça)
	draw_rect(Rect2(0, 0, 320, 12), Color8(84, 90, 100))
	var truss := Color8(58, 62, 70)
	var x := 0
	while x < 320:
		draw_line(Vector2(x, 0), Vector2(x + 10, 11), truss)
		draw_line(Vector2(x + 10, 11), Vector2(x + 20, 0), truss)
		x += 20
	draw_line(Vector2(0, 11), Vector2(320, 11), Color8(120, 126, 136))
	for i in 5:
		draw_rect(Rect2(rng.randf_range(0, 310), rng.randf_range(1, 9), 5, 2), Color(0.6, 0.35, 0.22, 0.6))
	# colunas metálicas nas laterais
	for cx in [0, 313]:
		draw_rect(Rect2(cx, 0, 7, 64), Color8(98, 104, 112))
		draw_rect(Rect2(cx + (1 if cx == 0 else 5), 0, 1, 64), Color8(130, 136, 146))
		draw_rect(Rect2(cx - 1, 60, 9, 4), Color8(76, 80, 88))
	# linhas da quadra (levemente gastas)
	var lc := Color(0.93, 0.92, 0.86, 0.85)
	draw_line(Vector2(14, 61), Vector2(306, 61), lc)
	draw_line(Vector2(14, 61), Vector2(14, 180), lc)
	draw_line(Vector2(306, 61), Vector2(306, 180), lc)
	draw_rect(Rect2(130, 61, 60, 52), lc, false, 1.0)
	draw_arc(Vector2(160, 113), 20.0, 0.0, PI, 24, lc, 1.0)
	draw_arc(Vector2(160, 66), 96.0, deg_to_rad(12), deg_to_rad(168), 48, lc, 1.0)
	var end_y := 66.0 + 96.0 * sin(deg_to_rad(12))
	var end_dx := 96.0 * cos(deg_to_rad(12))
	draw_line(Vector2(160 - end_dx, 61), Vector2(160 - end_dx, end_y), lc)
	draw_line(Vector2(160 + end_dx, 61), Vector2(160 + end_dx, end_y), lc)
	for i in 22:
		draw_rect(Rect2(rng.randf_range(14, 300), rng.randf_range(62, 176), 2, 1), Color8(176, 172, 162))


func _draw_light() -> void:
	draw_rect(Rect2(0, 0, 320, 14), Color(0, 0, 0, 0.10))
	var warm := Color(1.0, 0.96, 0.78, 0.10)
	var soft := Color(1.0, 0.96, 0.78, 0.07)
	for side in [1, -1]:
		var o := 0.0 if side == 1 else 320.0
		# Feixe de luz dividido em dois triângulos para garantir triangulação perfeita sem warning
		draw_colored_polygon(PackedVector2Array([Vector2(o, 24), Vector2(o + side * 86.0, 180), Vector2(o, 60)]), warm)
		draw_colored_polygon(PackedVector2Array([Vector2(o, 60), Vector2(o + side * 86.0, 180), Vector2(o + side * 130.0, 180)]), warm)
		draw_colored_polygon(PackedVector2Array([Vector2(o, 70), Vector2(o + side * 30.0, 180), Vector2(o, 100)]), soft)
		draw_colored_polygon(PackedVector2Array([Vector2(o, 100), Vector2(o + side * 30.0, 180), Vector2(o + side * 62.0, 180)]), soft)

class_name BikeSprites
extends RefCounted
## Monta os SpriteFrames de um personagem pedalando bicicleta a partir de assets/sprites/characters/<id>.png.
## Layout: 96x96 px. 4 colunas (frames) x 4 linhas (down, left, right, up). Frame 24x24 px.
## Coluna 0 = parado; colunas 0-3 = ciclo de pedalada.

const FRAME_W := 24
const FRAME_H := 24
const DIRS: Array[String] = ["down", "left", "right", "up"]


static func build(bike_id: String) -> SpriteFrames:
	var path := "res://assets/sprites/characters/%s.png" % bike_id
	var sheet: Texture2D
	if ResourceLoader.exists(path):
		sheet = load(path)
	else:
		push_warning("Sprite de bicicleta ausente: " + path)
		var img := Image.create(FRAME_W * 4, FRAME_H * 4, false, Image.FORMAT_RGBA8)
		img.fill(Color(0.2, 0.6, 0.9, 0.8))
		sheet = ImageTexture.create_from_image(img)

	var frames := SpriteFrames.new()
	if frames.has_animation("default"):
		frames.remove_animation("default")

	for row in DIRS.size():
		var d: String = DIRS[row]
		var idle := "idle_" + d
		frames.add_animation(idle)
		frames.set_animation_speed(idle, 1.0)
		frames.set_animation_loop(idle, true)
		frames.add_frame(idle, _atlas(sheet, 0, row))

		var pedal := "pedal_" + d
		frames.add_animation(pedal)
		frames.set_animation_speed(pedal, 8.0)
		frames.set_animation_loop(pedal, true)
		for col in 4:
			frames.add_frame(pedal, _atlas(sheet, col, row))

	return frames


static func _atlas(sheet: Texture2D, col: int, row: int) -> AtlasTexture:
	var a := AtlasTexture.new()
	a.atlas = sheet
	a.region = Rect2(col * FRAME_W, row * FRAME_H, FRAME_W, FRAME_H)
	return a

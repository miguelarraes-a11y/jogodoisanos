class_name CharacterSprites
## Monta os SpriteFrames de um personagem a partir de assets/sprites/characters/<id>.png.
## Para trocar o visual: substitua o PNG (mesmo layout) — nenhuma lógica muda.
## Layout: 64x96 px. 4 colunas (frames) x 4 linhas (down, left, right, up). Frame 16x24.
## Coluna 0 = parado; colunas 0-3 = ciclo de caminhada.

const FRAME_W := 16
const FRAME_H := 24
const DIRS: Array[String] = ["down", "left", "right", "up"]


static func build(character_id: String) -> SpriteFrames:
	var path := "res://assets/sprites/characters/%s.png" % character_id
	var sheet: Texture2D
	if ResourceLoader.exists(path):
		sheet = load(path)
	else:
		push_warning("Sprite ausente: " + path + " (usando marcador)")
		var img := Image.create(FRAME_W * 4, FRAME_H * 4, false, Image.FORMAT_RGBA8)
		img.fill(Color(1, 0, 1, 0.6))
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
		var walk := "walk_" + d
		frames.add_animation(walk)
		frames.set_animation_speed(walk, 8.0)
		frames.set_animation_loop(walk, true)
		for col in 4:
			frames.add_frame(walk, _atlas(sheet, col, row))
	return frames


static func _atlas(sheet: Texture2D, col: int, row: int) -> AtlasTexture:
	var a := AtlasTexture.new()
	a.atlas = sheet
	a.region = Rect2(col * FRAME_W, row * FRAME_H, FRAME_W, FRAME_H)
	return a

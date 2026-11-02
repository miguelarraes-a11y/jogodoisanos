class_name UiStyle
## Estilo visual compartilhado (moldura creme com borda marrom, como a caixa de diálogo).

const BG := Color(1.0, 0.945, 0.812)
const BORDER := Color(0.541, 0.353, 0.169)
const TEXT := Color(0.290, 0.184, 0.102)


static func box(bg: Color = BG, border: Color = BORDER, radius: int = 4, width: int = 2) -> StyleBoxFlat:
	var s := StyleBoxFlat.new()
	s.bg_color = bg
	s.border_color = border
	s.set_border_width_all(width)
	s.set_corner_radius_all(radius)
	return s


static func make_label(text: String, size: int = 14, color: Color = TEXT) -> Label:
	var l := Label.new()
	l.text = text
	l.add_theme_font_size_override("font_size", size)
	l.add_theme_color_override("font_color", color)
	l.mouse_filter = Control.MOUSE_FILTER_IGNORE
	return l


## Texto branco com contorno, para o HUD durante o jogo.
static func hud_label(text: String, size: int = 13) -> Label:
	var l := make_label(text, size, Color.WHITE)
	l.add_theme_color_override("font_outline_color", Color.BLACK)
	l.add_theme_constant_override("outline_size", 3)
	return l

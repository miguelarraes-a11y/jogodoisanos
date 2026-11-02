class_name PhotoRetrospective
extends CanvasLayer
## Sistema de Retrospectiva com Fotografias Reais em Altíssima Definição.
## Apresenta as fotos originais de Miguel e Maria Fernanda sobre fundo preto puro,
## com preservação estrita de proporção, centralização, mipmapping, filtragem linear,
## resolução máxima nativa do monitor e tipografia cinematográfica.

signal photo_finished
signal all_finished

var bg: ColorRect
var photo_rect: TextureRect
var message_container: VBoxContainer
var title_lbl: Label
var subtitle_lbl: Label
var particles: CelebrationParticles

var _texture_cache: Dictionary = {}
var _prev_content_scale_mode: Window.ContentScaleMode


func _init() -> void:
	layer = 30


func _ready() -> void:
	# Ativa o modo de escala em alta definição para fotos e textos
	_prev_content_scale_mode = get_tree().root.content_scale_mode
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS

	# Fundo totalmente preto
	bg = ColorRect.new()
	bg.color = Color.BLACK
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	add_child(bg)

	# Exibição da fotografia real com proporção intocada e qualidade máxima (Linear + Mipmaps)
	photo_rect = TextureRect.new()
	photo_rect.texture_filter = CanvasItem.TEXTURE_FILTER_LINEAR_WITH_MIPMAPS
	photo_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	photo_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	photo_rect.set_anchors_preset(Control.PRESET_FULL_RECT)
	photo_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	photo_rect.modulate = Color(1.0, 1.0, 1.0, 0.0)
	add_child(photo_rect)

	# Partículas sutis para momentos de celebração
	particles = CelebrationParticles.new()
	particles.position = Vector2(160, 90)
	add_child(particles)

	# Container de textos cinematográficos
	message_container = VBoxContainer.new()
	message_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	message_container.alignment = BoxContainer.ALIGNMENT_CENTER
	message_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(message_container)

	title_lbl = Label.new()
	title_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	title_lbl.add_theme_font_size_override("font_size", 16)
	title_lbl.add_theme_color_override("font_color", Color.WHITE)
	title_lbl.modulate = Color(1.0, 1.0, 1.0, 0.0)
	message_container.add_child(title_lbl)

	subtitle_lbl = Label.new()
	subtitle_lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_lbl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	subtitle_lbl.add_theme_font_size_override("font_size", 12)
	subtitle_lbl.add_theme_color_override("font_color", Color("e2d4be"))
	subtitle_lbl.modulate = Color(1.0, 1.0, 1.0, 0.0)
	message_container.add_child(subtitle_lbl)


func _load_hd_texture(tex_path: String) -> Texture2D:
	if _texture_cache.has(tex_path):
		return _texture_cache[tex_path]

	# Carrega o arquivo de imagem original diretamente em memória sem perdas de compressão
	var global_path := ProjectSettings.globalize_path(tex_path)
	if FileAccess.file_exists(global_path):
		var img := Image.load_from_file(global_path)
		if img != null and not img.is_empty():
			img.generate_mipmaps()
			var tex := ImageTexture.create_from_image(img)
			_texture_cache[tex_path] = tex
			return tex

	# Fallback padrão pelo ResourceLoader
	if ResourceLoader.exists(tex_path):
		var tex: Texture2D = load(tex_path)
		_texture_cache[tex_path] = tex
		return tex

	push_warning("Fotografia não encontrada: " + tex_path)
	return null


func show_photo(tex_path: String, duration: float = 4.0, fade_time: float = 1.0) -> void:
	var tex := _load_hd_texture(tex_path)
	if tex == null:
		await get_tree().create_timer(duration).timeout
		return

	photo_rect.texture = tex

	# Fade in da foto
	var tw_in := create_tween()
	tw_in.tween_property(photo_rect, "modulate:a", 1.0, fade_time).set_trans(Tween.TRANS_SINE)
	await tw_in.finished

	# Tempo de visualização
	await get_tree().create_timer(duration).timeout

	# Fade out da foto
	var tw_out := create_tween()
	tw_out.tween_property(photo_rect, "modulate:a", 0.0, fade_time).set_trans(Tween.TRANS_SINE)
	await tw_out.finished
	photo_rect.texture = null


func show_card(title_text: String, sub_text: String = "", duration: float = 3.5, font_size: int = 16, title_color: Color = Color.WHITE) -> void:
	title_lbl.text = title_text
	title_lbl.add_theme_font_size_override("font_size", font_size)
	title_lbl.add_theme_color_override("font_color", title_color)

	subtitle_lbl.text = sub_text
	subtitle_lbl.visible = sub_text != ""

	# Fade in do texto
	var tw := create_tween().set_parallel(true)
	tw.tween_property(title_lbl, "modulate:a", 1.0, 1.0)
	if sub_text != "":
		tw.tween_property(subtitle_lbl, "modulate:a", 1.0, 1.0)
	await tw.finished

	await get_tree().create_timer(duration).timeout

	# Fade out do texto
	var tw_out := create_tween().set_parallel(true)
	tw_out.tween_property(title_lbl, "modulate:a", 0.0, 0.8)
	tw_out.tween_property(subtitle_lbl, "modulate:a", 0.0, 0.8)
	await tw_out.finished

	title_lbl.text = ""
	subtitle_lbl.text = ""


func trigger_stars_celebration() -> void:
	particles.start_burst(1.2)

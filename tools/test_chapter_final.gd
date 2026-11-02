extends Node

func _ready() -> void:
	print("========================================================")
	print("--- TEST RUNNER: VERIFICAÇÃO COMPLETA CAPÍTULO FINAL ---")
	print("========================================================")
	var errors: Array[String] = []

	# 1. Autoloads
	print("[Autoload] GameState presente: ", GameState != null)
	print("[Autoload] AudioManager presente: ", AudioManager != null)
	print("[Autoload] Dialogues presente: ", Dialogues != null)
	print("[Autoload] SceneManager presente: ", SceneManager != null)

	# 2. Assets Visuais de Pixel Art
	var visual_assets := [
		"res://assets/sprites/characters/miguel_kneel.png",
		"res://assets/sprites/ui/pixel_star.png",
		"res://assets/sprites/ui/confetti.png",
		"res://assets/sprites/ui/pixel_heart.png"
	]
	for a in visual_assets:
		if ResourceLoader.exists(a):
			var res = load(a)
			if res != null:
				print("[OK] Asset visual carregado: %s" % a.get_file())
			else:
				errors.append("Falha ao instanciar: " + a)
		else:
			errors.append("Arquivo visual inexistente: " + a)

	# 3. Fotografias Reais (100% Intocadas em Alta Definição)
	var photo_assets := [
		"res://assets/photos/foto_01.jpg",
		"res://assets/photos/foto_02.jpg",
		"res://assets/photos/foto_03.png",
		"res://assets/photos/foto_04.png",
		"res://assets/photos/foto_05.jpg",
		"res://assets/photos/foto_06.jpg",
		"res://assets/photos/foto_07.jpg",
		"res://assets/photos/foto_08.png",
		"res://assets/photos/foto_09.jpg",
		"res://assets/photos/foto_10.png"
	]
	for p in photo_assets:
		if ResourceLoader.exists(p):
			var res = load(p)
			if res != null:
				print("[OK] Fotografia real carregada: %s (tamanho: %dx%d)" % [p.get_file(), res.get_width(), res.get_height()])
			else:
				errors.append("Falha ao carregar foto: " + p)
		else:
			errors.append("Fotografia inexistente: " + p)

	# 4. Assets de Áudio
	var audio_assets := [
		"res://assets/audio/sparkle.wav",
		"res://assets/audio/music_love_theme.wav"
	]
	for snd in audio_assets:
		if ResourceLoader.exists(snd):
			var res = load(snd)
			if res != null:
				print("[OK] Asset de áudio carregado: %s" % snd.get_file())
			else:
				errors.append("Falha ao instanciar áudio: " + snd)
		else:
			errors.append("Arquivo de áudio inexistente: " + snd)

	# 5. Diálogos do Capítulo Final
	var test_dialog_ids := [
		"cfinal_s1_caminhada",
		"cfinal_s1_maria_concorda",
		"cfinal_s1_pedido_miguel",
		"cfinal_s1_resposta_maria",
		"cfinal_s3_data_inicio",
		"cfinal_s3_subtitulo",
		"cfinal_s5_msg_1",
		"cfinal_s5_msg_2",
		"cfinal_s5_um_ano",
		"cfinal_s5_data_1ano",
		"cfinal_s6_e_agora",
		"cfinal_s6_dois_anos",
		"cfinal_s6_data_2anos",
		"cfinal_s7_dec1",
		"cfinal_s7_dec2",
		"cfinal_s7_dec3",
		"cfinal_s7_dec4",
		"cfinal_s8_nomes",
		"cfinal_s8_final"
	]
	for d_id in test_dialog_ids:
		var line: Dictionary = Dialogues.get_line(d_id)
		if line.get("text", "").begins_with("[FALA PENDENTE"):
			errors.append("Fala não encontrada no Dialogues: " + d_id)
		else:
			print("[OK] Diálogo encontrado [%s]: \"%s\"" % [d_id, line.get("text", "").replace("\n", " ")])

	# 6. Sistemas Customizados (CelebrationParticles, PhotoRetrospective, FontVariation)
	var celebration := CelebrationParticles.new()
	if celebration != null:
		print("[OK] CelebrationParticles instanciado com sucesso")
		celebration.queue_free()
	else:
		errors.append("Falha ao instanciar CelebrationParticles")

	var retro := PhotoRetrospective.new()
	if retro != null:
		print("[OK] PhotoRetrospective instanciado com sucesso")
		for p in photo_assets:
			var hd_tex = retro._load_hd_texture(p)
			if hd_tex != null:
				print("[OK] Foto HD carregada com sucesso: %s (%dx%d)" % [p.get_file(), hd_tex.get_width(), hd_tex.get_height()])
			else:
				errors.append("Falha no carregamento HD de: " + p)
		retro.queue_free()
	else:
		errors.append("Falha ao instanciar PhotoRetrospective")

	# Teste de FontVariation com fallback
	var sf := SystemFont.new()
	sf.font_names = PackedStringArray(["Segoe UI Emoji", "Segoe UI Symbol", "Apple Color Emoji", "Noto Color Emoji", "DejaVu Sans", "Arial"])
	var fv := FontVariation.new()
	fv.base_font = load("res://assets/fonts/m5x7.ttf")
	fv.fallbacks = [sf]
	if fv.has_char("∞".unicode_at(0)) and fv.has_char("❤".unicode_at(0)):
		print("[OK] FontVariation suporta '∞' e '❤️' com sucesso!")
	else:
		errors.append("FontVariation não suporta glifos de infinito ou coração")

	# 7. Instanciar todas as cenas do Capítulo Final
	var scenes := [
		"res://chapters/chapter_final/scene_01_o_pedido_de_namoro/scene_01.tscn",
		"res://chapters/chapter_final/scene_02_explosao_de_felicidade/scene_02.tscn",
		"res://chapters/chapter_final/scene_03_o_primeiro_dia/scene_03.tscn",
		"res://chapters/chapter_final/scene_04_nossa_historia_e_dois_anos/scene_04.tscn",
		"res://chapters/chapter_final/scene_08_encerramento_definitivo/scene_08.tscn"
	]
	for scn_path in scenes:
		if ResourceLoader.exists(scn_path):
			var packed: PackedScene = load(scn_path)
			if packed != null:
				var instance = packed.instantiate()
				if instance != null:
					print("[OK] Cena carregada e instanciada: %s" % scn_path.get_file())
					instance.queue_free()
				else:
					errors.append("Falha ao instanciar cena: " + scn_path)
			else:
				errors.append("Falha ao carregar PackedScene: " + scn_path)
		else:
			errors.append("Cena inexistente: " + scn_path)

	# 8. Relatório Final
	print("--------------------------------------------------")
	if errors.is_empty():
		print(">>> TODOS OS TESTES DO CAPÍTULO FINAL PASSARAM COM SUCESSO! <<<")
		print("==================================================")
		get_tree().quit(0)
	else:
		printerr(">>> ENCONTRADOS %d ERROS:" % errors.size())
		for e in errors:
			printerr("  - " + e)
		print("==================================================")
		get_tree().quit(1)

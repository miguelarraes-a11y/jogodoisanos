extends SceneTree

func _init() -> void:
	print("--- INICIANDO VERIFICAÇÃO AUTOMATIZADA DO CAPÍTULO 3 ---")
	var errors: Array[String] = []

	# 1. Verificar arquivos de assets
	var assets_to_check := [
		"res://assets/tiles/banco_pedra.png",
		"res://assets/sprites/ui/selfie_casal.png",
		"res://assets/sprites/ui/pixel_heart.png",
		"res://assets/audio/camera_shutter.wav",
		"res://assets/audio/music_closer_to_you.wav",
		"res://assets/audio/kiss_chime.wav",
	]
	for a in assets_to_check:
		if ResourceLoader.exists(a):
			var res = load(a)
			if res != null:
				print("[OK] Asset carregado com sucesso: %s" % a)
			else:
				errors.append("Falha ao instanciar recurso: " + a)
		else:
			errors.append("Arquivo de asset não encontrado: " + a)

	# 2. Verificar diálogos do Capítulo 3
	var dialog_file := "res://data/dialogues/chapter_3.json"
	if FileAccess.file_exists(dialog_file):
		var f := FileAccess.open(dialog_file, FileAccess.READ)
		var text := f.get_as_text()
		var parsed = JSON.parse_string(text)
		if parsed is Dictionary and parsed.has("dialogues"):
			var count = parsed["dialogues"].size()
			print("[OK] Diálogos do Capítulo 3 lidos com sucesso (%d falas)" % count)
		else:
			errors.append("Estrutura inválida em data/dialogues/chapter_3.json")
	else:
		errors.append("Arquivo não encontrado: " + dialog_file)

	# 3. Verificar cenas do Capítulo 3
	var scenes := [
		"res://chapters/chapter_3/scene_01_marcando_encontro/scene_01.tscn",
		"res://chapters/chapter_3/scene_02_o_novo_encontro/scene_02.tscn",
		"res://chapters/chapter_3/scene_03_banco_de_pedra/scene_03.tscn",
		"res://chapters/chapter_3/scene_04_tirando_fotos/scene_04.tscn",
		"res://chapters/chapter_3/scene_05_o_beijo/scene_05.tscn",
		"res://chapters/chapter_3/scene_06_caminhada_avo/scene_06.tscn",
		"res://chapters/chapter_3/scene_07_despedida_avo/scene_07.tscn",
		"res://chapters/chapter_3/scene_08_encerramento/scene_08.tscn"
	]

	for scn_path in scenes:
		if ResourceLoader.exists(scn_path):
			var packed := load(scn_path) as PackedScene
			if packed != null:
				var node := packed.instantiate()
				if node != null:
					print("[OK] Cena carregada e instanciada: %s (Tipo: %s)" % [scn_path.get_file(), node.get_class()])
					node.queue_free()
				else:
					errors.append("Falha ao instanciar cena: " + scn_path)
			else:
				errors.append("Falha ao carregar PackedScene: " + scn_path)
		else:
			errors.append("Cena não encontrada: " + scn_path)

	# 4. Verificar Minigame de Foto
	var photo_minigame_script := load("res://minigames/photo/photo_minigame.gd")
	if photo_minigame_script != null:
		var mg = photo_minigame_script.new()
		if mg != null:
			print("[OK] Minigame de foto instanciado com sucesso")
			mg.queue_free()
		else:
			errors.append("Falha ao instanciar PhotoMinigame")
	else:
		errors.append("Falha ao carregar script photo_minigame.gd")

	print("\n--- RESULTADO FINAL ---")
	if errors.is_empty():
		print(">> TODOS OS TESTES PASSARAM COM 100% DE SUCESSO! <<")
		quit(0)
	else:
		print("ERROS ENCONTRADOS:")
		for err in errors:
			printerr(" - ", err)
		quit(1)

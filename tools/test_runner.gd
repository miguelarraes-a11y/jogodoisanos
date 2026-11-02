extends Node

func _ready() -> void:
	print("==================================================")
	print("--- TEST RUNNER: VERIFICAÇÃO COMPLETA CAPÍTULO 3 ---")
	print("==================================================")
	var errors: Array[String] = []

	# 1. Verificar Autoloads
	print("[Autoload] GameState presente: ", GameState != null)
	print("[Autoload] AudioManager presente: ", AudioManager != null)
	print("[Autoload] Dialogues presente: ", Dialogues != null)
	print("[Autoload] SceneManager presente: ", SceneManager != null)

	# 2. Verificar diálogos do Capítulo 3 no Dialogues autoload
	var test_dialog_ids := [
		"c3_s1_miguel_msg1",
		"c3_s1_maria_msg1",
		"c3_s2_miguel_oi",
		"c3_s3_banco_sentei",
		"c3_s3_opcao_timida",
		"c3_s3_opcao_engracada",
		"c3_s3_opcao_carinhosa",
		"c3_s4_ideia_foto",
		"c3_s5_beijo_narracao",
		"c3_s6_tarde_fim",
		"c3_s7_beijo_despedida",
		"c3_s8_fim_texto"
	]
	for d_id in test_dialog_ids:
		var line: Dictionary = Dialogues.get_line(d_id)
		if line.get("text", "").begins_with("[FALA PENDENTE"):
			errors.append("Fala não encontrada no Dialogues: " + d_id)
		else:
			print("[OK] Diálogo encontrado [%s]: \"%s\"" % [d_id, line.get("text", "").substr(0, 30) + "..."])

	# 3. Verificar assets do Capítulo 3
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
				print("[OK] Asset carregado: %s" % a)
			else:
				errors.append("Falha ao instanciar recurso: " + a)
		else:
			errors.append("Asset não encontrado: " + a)

	# 4. Instanciar todas as 8 cenas do Capítulo 3
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
					print("[OK] Cena carregada e instanciada sem erro: %s" % scn_path.get_file())
					node.queue_free()
				else:
					errors.append("Falha ao instanciar: " + scn_path)
			else:
				errors.append("PackedScene nula: " + scn_path)
		else:
			errors.append("Arquivo de cena inexistente: " + scn_path)

	# 5. Minigame de foto
	var photo_script := load("res://minigames/photo/photo_minigame.gd")
	if photo_script != null:
		var mg = photo_script.new()
		if mg != null:
			print("[OK] PhotoMinigame instanciado com sucesso")
			mg.queue_free()
		else:
			errors.append("Falha ao instanciar PhotoMinigame")
	else:
		errors.append("Falha ao carregar script de photo_minigame.gd")

	print("\n==================================================")
	if errors.is_empty():
		print(">> SUCESSO TOTAL: TODAS AS 8 CENAS E ASSETS DO CAPÍTULO 3 ESTÃO 100% VALIDADOS! <<")
		print("==================================================")
		get_tree().quit(0)
	else:
		print(">> FALHAS ENCONTRADAS <<")
		for err in errors:
			printerr("ERRO: ", err)
		print("==================================================")
		get_tree().quit(1)

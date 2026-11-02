extends Node

func _ready() -> void:
	print("==================================================")
	print("--- TEST RUNNER: VERIFICAÇÃO COMPLETA CAPÍTULO 4 ---")
	print("==================================================")
	var errors: Array[String] = []

	# 1. Autoloads
	print("[Autoload] GameState presente: ", GameState != null)
	print("[Autoload] AudioManager presente: ", AudioManager != null)
	print("[Autoload] Dialogues presente: ", Dialogues != null)
	print("[Autoload] SceneManager presente: ", SceneManager != null)

	# 2. Assets Visuais do Capítulo 4
	var visual_assets := [
		"res://assets/tiles/asphalt_bike_lane.png",
		"res://assets/tiles/bus_stop.png",
		"res://assets/tiles/bus_urban.png",
		"res://assets/tiles/bus_interior.png",
		"res://assets/tiles/tree_parque.png",
		"res://assets/tiles/kiosk_wood.png",
		"res://assets/tiles/mountain_bg.png",
		"res://assets/sprites/characters/miguel_bike.png",
		"res://assets/sprites/characters/maria_bike.png",
		"res://assets/sprites/characters/family_member_a.png",
		"res://assets/sprites/characters/family_member_b.png",
		"res://assets/sprites/characters/family_member_c.png",
		"res://assets/sprites/ui/race_flag.png"
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

	# 3. Assets de Áudio do Capítulo 4
	var audio_assets := [
		"res://assets/audio/race_beep.wav",
		"res://assets/audio/race_go.wav",
		"res://assets/audio/bike_bell.wav",
		"res://assets/audio/bus_engine.wav",
		"res://assets/audio/music_park_ride.wav",
		"res://assets/audio/music_bike_race.wav",
		"res://assets/audio/music_family.wav"
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

	# 4. Diálogos do Capítulo 4
	var test_dialog_ids := [
		"c4_s1_miguel_msg1",
		"c4_s1_maria_msg1",
		"c4_s2_miguel_chegada",
		"c4_s2_beijo_narracao",
		"c4_s3_janela_inicio",
		"c4_s4_vista_parque",
		"c4_s5_dica_pedal",
		"c4_s6_contagem",
		"c4_s6_vitoria_miguel",
		"c4_s6_vitoria_maria",
		"c4_s7_fim_tarde",
		"c4_s8_passagem_tempo",
		"c4_s9_chegada_maria",
		"c4_s9_familiar_miguel_1",
		"c4_s10_chegada_miguel",
		"c4_s10_familiar_maria_1",
		"c4_s11_momento_juntos",
		"c4_s11_fim_texto"
	]
	for d_id in test_dialog_ids:
		var line: Dictionary = Dialogues.get_line(d_id)
		if line.get("text", "").begins_with("[FALA PENDENTE"):
			errors.append("Fala não encontrada no Dialogues: " + d_id)
		else:
			print("[OK] Diálogo encontrado [%s]: \"%s\"" % [d_id, line.get("text", "").substr(0, 30) + "..."])

	# 5. Instanciar todas as 11 cenas do Capítulo 4
	var scenes := [
		"res://chapters/chapter_4/scene_01_um_novo_passeio/scene_01.tscn",
		"res://chapters/chapter_4/scene_02_o_reencontro_e_beijo/scene_02.tscn",
		"res://chapters/chapter_4/scene_03_viagem_onibus/scene_03.tscn",
		"res://chapters/chapter_4/scene_04_chegada_parque/scene_04.tscn",
		"res://chapters/chapter_4/scene_05_passeio_bicicleta/scene_05.tscn",
		"res://chapters/chapter_4/scene_06_corrida_bicicleta/scene_06.tscn",
		"res://chapters/chapter_4/scene_07_voltando_para_casa/scene_07.tscn",
		"res://chapters/chapter_4/scene_08_passagem_tempo/scene_08.tscn",
		"res://chapters/chapter_4/scene_09_familia_miguel/scene_09.tscn",
		"res://chapters/chapter_4/scene_10_familia_maria/scene_10.tscn",
		"res://chapters/chapter_4/scene_11_encerramento/scene_11.tscn"
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

	# 6. Sistemas Reutilizáveis
	var bike = BikeController.new()
	if bike != null:
		print("[OK] BikeController instanciado com sucesso")
		bike.queue_free()
	else:
		errors.append("Falha ao instanciar BikeController")

	var race_mg = BikeRaceMinigame.new()
	if race_mg != null:
		print("[OK] BikeRaceMinigame instanciado com sucesso")
		race_mg.queue_free()
	else:
		errors.append("Falha ao instanciar BikeRaceMinigame")

	var bus_act = BusActor.new()
	if bus_act != null:
		print("[OK] BusActor instanciado com sucesso")
		bus_act.queue_free()
	else:
		errors.append("Falha ao instanciar BusActor")

	var fam_npc = FamilyNpc.new()
	if fam_npc != null:
		print("[OK] FamilyNpc instanciado com sucesso")
		fam_npc.queue_free()
	else:
		errors.append("Falha ao instanciar FamilyNpc")

	print("\n==================================================")
	if errors.is_empty():
		print(">> SUCESSO TOTAL: TODAS AS 11 CENAS, ASSETS E SISTEMAS DO CAPÍTULO 4 ESTÃO 100% VALIDADOS! <<")
		print("==================================================")
		get_tree().quit(0)
	else:
		print(">> FALHAS ENCONTRADAS <<")
		for err in errors:
			printerr("ERRO: ", err)
		print("==================================================")
		get_tree().quit(1)

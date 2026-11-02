extends Node
## CAPÍTULO FINAL — CENAS 04 A 07: RETROSPECTIVA COM FOTOGRAFIAS REAIS & FINALMENTE 2 ANOS
## Exibição intocada das fotografias reais de Miguel e Maria Fernanda em qualidade máxima (HD/4K),
## sobre fundo preto puro, com as mensagens oficiais, celebração de 1 ano (03/11/2025) e 2 anos (03/11/2026).

const NEXT_SCENE := "res://chapters/chapter_final/scene_08_encerramento_definitivo/scene_08.tscn"

var runner: CutsceneRunner
var retro: PhotoRetrospective


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "chapter_final"
	GameState.scene_id = "scene_04"

	runner = CutsceneRunner.new()
	add_child(runner)

	retro = PhotoRetrospective.new()
	add_child(retro)

	_play()


func _play() -> void:
	AudioManager.play_music("music_love_theme", 1.5, -3.0)

	# --- PARTE 1: Nossas Primeiras Lembranças ---
	await retro.show_card("Meu amor, muito obrigado pelo tempo que passamos juntos.", "", 3.5, 14, Color("f4ead2"))
	await retro.show_photo("res://assets/photos/foto_01.jpg", 4.0, 0.9)
	await retro.show_photo("res://assets/photos/foto_07.jpg", 4.0, 0.9)

	await retro.show_card("Cada momento foi incrível, e eu te amo cada vez mais.", "", 3.5, 14, Color("f4ead2"))
	await retro.show_photo("res://assets/photos/foto_02.jpg", 4.2, 0.9)
	await retro.show_photo("res://assets/photos/foto_03.png", 4.0, 0.9)
	await retro.show_photo("res://assets/photos/foto_09.jpg", 4.0, 0.9)

	# --- PARTE 2: Primeiro Aniversário de Namoro (03/11/2025) ---
	await retro.show_card("Já se passou um ano...", "03/11/2025", 4.0, 16, Color("ffd166"))
	await retro.show_photo("res://assets/photos/foto_04.png", 4.2, 0.9)
	await retro.show_photo("res://assets/photos/foto_06.jpg", 4.0, 0.9)
	await retro.show_photo("res://assets/photos/foto_08.png", 4.0, 0.9)

	# --- PARTE 3: Comemoração de 2 Anos (03/11/2026) ---
	await retro.show_card("E agora...", "", 2.8, 15, Color("f4ead2"))

	retro.trigger_stars_celebration()
	AudioManager.play_sfx("sparkle", 2.0)
	await retro.show_card("FINALMENTE 2 ANOS!!!!", "03/11/2026", 4.5, 20, Color("ffd166"))

	await retro.show_photo("res://assets/photos/foto_05.jpg", 4.2, 0.9)
	await retro.show_photo("res://assets/photos/foto_10.png", 4.2, 0.9)

	# --- PARTE 4: A Declaração Final de Dois Anos ---
	await retro.show_card("Dois anos desde a melhor escolha da minha vida,\nque foi te pedir em namoro.", "", 4.2, 14, Color("f4ead2"))
	await retro.show_photo("res://assets/photos/foto_01.jpg", 3.6, 0.8)

	await retro.show_card("Muito obrigado, meu amor, por ser essa mulher incrível\ne por sempre estar ao meu lado.", "", 4.2, 14, Color("f4ead2"))
	await retro.show_photo("res://assets/photos/foto_10.png", 3.6, 0.8)

	await retro.show_card("Eu te amo mais e mais, para sempre.", "", 3.8, 15, Color("f4ead2"))

	await retro.show_card("Esses são 2 de muitos anos juntos.", "", 4.2, 15, Color("ffd166"))
	await retro.show_photo("res://assets/photos/foto_05.jpg", 4.5, 1.0)

	# Transição suave para o encerramento definitivo
	await runner.wait(1.0)
	SceneManager.change_scene(NEXT_SCENE, 0.5)

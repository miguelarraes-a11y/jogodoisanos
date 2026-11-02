extends Node
## CENA 04 — O ABACATE. Cutscene com interação.
## 1) Rua em declive: iluminação de fim de tarde, Miguel descendo a rua para casa.
## 2) O abacate: percebe um abacate no chão, aproxima-se.
## 3) Chutes: jogador pressiona [Espaço] para chutar e tentar abrir a fruta.
## 4) Chamado da prima: escuta "Miguel!", tenta seguir, é chamado de novo, para e vira.
## 5) Transição suave para a Cena 05 (O primeiro olhar).

const AFTERNOON_SUNSET := Color(1.0, 0.88, 0.74)
const NEXT_SCENE := "res://chapters/prologue/scene_05_primeiro_olhar/scene_05.tscn"

var runner: CutsceneRunner
var camera: FollowCamera
var stage: Node2D
var miguel: Character
var avocado_sprite: Sprite2D
var avocado_pos: Vector2 = Vector2(235, 270)
var kick_count: int = 0
var kick_hint: Label


func _ready() -> void:
	GameState.controls_locked = true
	GameState.chapter_id = "prologue"
	GameState.scene_id = "scene_04"

	runner = CutsceneRunner.new()
	add_child(runner)

	stage = Node2D.new()
	add_child(stage)

	camera = FollowCamera.new()
	add_child(camera)
	camera.make_current()

	_play()


func _play() -> void:
	var street := Node2D.new()
	stage.add_child(street)

	var world := Node2D.new()
	world.y_sort_enabled = true
	street.add_child(world)

	StreetBuilder.build(street, world)

	# Iluminação suave de declive e fim de tarde
	var sunset_mod := CanvasModulate.new()
	sunset_mod.color = AFTERNOON_SUNSET
	stage.add_child(sunset_mod)

	# Abacate no chão
	avocado_sprite = Sprite2D.new()
	var avo_tex := load("res://assets/tiles/abacate.png")
	if avo_tex != null:
		avocado_sprite.texture = avo_tex
	avocado_sprite.hframes = 3
	avocado_sprite.frame = 0
	avocado_sprite.position = avocado_pos
	world.add_child(avocado_sprite)

	# Miguel descendo a rua
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = Vector2(235, 170)
	world.add_child(miguel)

	camera.set_world_limits(StreetBuilder.WORLD)
	camera.target = miguel
	camera.snap_to_target()

	AudioManager.play_sfx("ambient_street", -14.0, true)
	await runner.fade_from_black(1.0)
	await runner.wait(0.6)

	# 1-2) Miguel desce a rua caminhando até o abacate
	await runner.say(["s4_miguel_descendo"])
	await runner.walk_to(miguel, Vector2(235, 252))
	runner.face(miguel, "down")
	await runner.wait(0.5)
	await runner.say(["s4_miguel_abacate"])

	# 3-5) Interação dos chutes no abacate
	_build_kick_hint()
	await _interactive_kicking()
	_remove_kick_hint()
	await runner.wait(0.4)
	await runner.say(["s4_miguel_chute"])

	# 6-7) Enquanto distraído, escuta o primeiro chamado da prima
	await runner.wait(0.5)
	await runner.say(["prima_chama_1"])
	await runner.say(["s4_miguel_ouve"])

	# 8) Miguel hesita e tenta dar mais um passo descendo para casa
	await runner.wait(0.3)
	runner.face(miguel, "down")
	await runner.walk_to(miguel, miguel.position + Vector2(0, 16))
	await runner.wait(0.4)

	# 9) A prima o chama novamente
	await runner.say(["prima_chama_2"])

	# 10) Miguel para completamente e se vira para a calçada/para trás
	await runner.say(["s4_miguel_vira"])
	runner.face(miguel, "up")
	await runner.wait(0.8)

	# Transição contínua para a Cena 05
	GameState.scene_id = "scene_05"
	GameState.save_game()
	await runner.fade_black(0.8)
	SceneManager.change_scene(NEXT_SCENE, 0.4)


func _build_kick_hint() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)

	kick_hint = UiStyle.hud_label("[%s] Chutar o abacate" % InputConfig.label_for("confirm"), 9)
	kick_hint.set_anchors_preset(Control.PRESET_BOTTOM_WIDE)
	kick_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	kick_hint.position.y = 158
	layer.add_child(kick_hint)


func _remove_kick_hint() -> void:
	if kick_hint != null and is_instance_valid(kick_hint):
		kick_hint.get_parent().queue_free()


func _interactive_kicking() -> void:
	for kick in 3:
		# Aguarda ação do jogador com timeout suave
		var waited := 0.0
		while waited < 4.0:
			if Input.is_action_just_pressed("confirm") or Input.is_action_just_pressed("interact"):
				break
			await get_tree().process_frame
			waited += get_process_delta_time()

		# Chute
		AudioManager.play_sfx("avocado_kick", -2.0)
		kick_count += 1
		avocado_sprite.frame = mini(kick_count, 2)

		# O abacate rola morro abaixo
		var new_avo_y := avocado_sprite.position.y + 20.0
		var t := create_tween()
		t.tween_property(avocado_sprite, "position:y", new_avo_y, 0.35).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		await t.finished

		# Miguel acompanha o abacate
		await runner.walk_to(miguel, Vector2(miguel.position.x, avocado_sprite.position.y - 18.0))
		runner.face(miguel, "down")
		await runner.wait(0.3)

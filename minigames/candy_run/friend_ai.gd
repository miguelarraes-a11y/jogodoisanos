class_name FriendAI
extends Node
## IA simples para as amigas (Ana Clara e Gabriele) na Corrida dos Doces.
## Percorre o bairro procurando moradores com saquinhos disponíveis,
## caminha até eles, pega doces e segue para a próxima casa.

signal score_changed(friend_id: String, new_score: int)

var character: Character
var friend_id: String
var spots: Array = []
var score: int = 0
var active: bool = false

var _current_target: CandySpot = null
var _state: String = "idle"
var _timer: float = 0.0


func setup(p_character: Character, p_friend_id: String, p_spots: Array) -> void:
	character = p_character
	friend_id = p_friend_id
	spots = p_spots
	score = 0
	active = true
	_timer = randf_range(0.2, 1.2)


func _process(delta: float) -> void:
	if not active or character == null:
		return

	_timer -= delta
	match _state:
		"idle":
			if _timer <= 0.0:
				_pick_target()

		"walking":
			if _current_target == null or not is_instance_valid(_current_target):
				_state = "idle"
				_timer = 0.5
				return
			var target_pos: Vector2 = _current_target.approach_pos
			var diff := target_pos - character.global_position
			var dist := diff.length()
			if dist <= 12.0:
				character.ai_direction = Vector2.ZERO
				character.ai_running = false
				_state = "collecting"
				_timer = randf_range(0.8, 1.4)
				# Vira em direção ao morador
				if absf(diff.x) > absf(diff.y):
					character.facing = "right" if diff.x > 0.0 else "left"
				else:
					character.facing = "up" if target_pos.y > _current_target.position.y else "down"
				character.sprite.play("idle_" + character.facing)
			else:
				character.ai_direction = diff.normalized()
				character.ai_running = (randf() < 0.3)
				# Se o alvo esvaziou no caminho, repensa
				if not _current_target.has_candy() and randf() < 0.05:
					_pick_target()

		"collecting":
			character.ai_direction = Vector2.ZERO
			if _timer <= 0.0:
				if _current_target != null and is_instance_valid(_current_target) and _current_target.has_candy():
					if _current_target.try_take_candy(character):
						score += 1
						score_changed.emit(friend_id, score)
				_current_target = null
				_state = "idle"
				_timer = randf_range(0.6, 1.2)

		"wander":
			# Quando acabam todos os doces da rua
			character.ai_direction = Vector2.ZERO
			character.ai_running = false
			if _timer <= 0.0:
				_pick_target()


func _pick_target() -> void:
	var available: Array = []
	for s in spots:
		if s is CandySpot and is_instance_valid(s) and s.has_candy():
			available.append(s)

	if available.is_empty():
		_state = "wander"
		_timer = 2.0
		character.ai_direction = Vector2.ZERO
		return

	# Escolhe um ponto disponível, preferindo os razoavelmente próximos
	available.sort_custom(func(a: CandySpot, b: CandySpot) -> bool:
		return a.global_position.distance_to(character.global_position) < b.global_position.distance_to(character.global_position)
	)
	var pick_idx := randi() % mini(available.size(), 3)
	_current_target = available[pick_idx]
	_state = "walking"


func stop() -> void:
	active = false
	if character != null:
		character.ai_direction = Vector2.ZERO
		character.ai_running = false
		character.sprite.play("idle_" + character.facing)

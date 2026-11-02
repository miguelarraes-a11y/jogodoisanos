class_name UnoAI
extends RefCounted
## Inteligência Estratégica Avançada para o bot de Maria Fernanda no UNO.
## Avalia o estado da partida, contagem de cartas do adversário, cores predominantes
## e momento ideal para cartas de ataque (+2, +4, Bloqueio, Inverter).

var opponent_missing_colors: Dictionary = {} # Cores que o jogador não tinha quando comprou


func record_opponent_drew(active_color: UnoCard.CardColor) -> void:
	if active_color != UnoCard.CardColor.WILD:
		opponent_missing_colors[active_color] = true


func record_opponent_played(played_color: UnoCard.CardColor) -> void:
	opponent_missing_colors.erase(played_color)


## Escolhe a melhor jogada da mão. Retorna null se não houver carta jogável.
func choose_card(hand: Array[UnoCard], top_card: UnoCard, active_color: UnoCard.CardColor, opponent_card_count: int) -> UnoCard:
	var valid_moves: Array[UnoCard] = []
	for c in hand:
		if c.can_play_on(top_card, active_color):
			valid_moves.append(c)

	if valid_moves.is_empty():
		return null

	if valid_moves.size() == 1:
		return valid_moves[0]

	# Avaliação heurística detalhada para cada jogada válida
	var best_card: UnoCard = null
	var best_score: float = -9999.0

	var hand_color_counts := _count_hand_colors(hand)

	for c in valid_moves:
		var score := 0.0

		# 1) Reação à contagem de cartas do oponente (Miguel)
		if opponent_card_count <= 2:
			# MODO PERIGO EXTREMO: Miguel está prestes a bater!
			match c.card_type:
				UnoCard.CardType.WILD_DRAW_FOUR:
					score += 150.0 # Força 4 cartas e bloqueia vitória
				UnoCard.CardType.DRAW_TWO:
					score += 130.0 # Força 2 cartas e bloqueia vitória
				UnoCard.CardType.SKIP, UnoCard.CardType.REVERSE:
					score += 110.0 # Pula o turno de Miguel no 1v1
				UnoCard.CardType.WILD:
					score += 80.0
				UnoCard.CardType.NUMBER:
					score += 20.0
		elif opponent_card_count <= 4:
			# Miguel com poucas cartas
			match c.card_type:
				UnoCard.CardType.DRAW_TWO: score += 70.0
				UnoCard.CardType.SKIP, UnoCard.CardType.REVERSE: score += 60.0
				UnoCard.CardType.WILD_DRAW_FOUR: score += 50.0
				UnoCard.CardType.WILD: score += 30.0
				UnoCard.CardType.NUMBER: score += 25.0
		else:
			# Partida normal: preservar cartas especiais para o final
			match c.card_type:
				UnoCard.CardType.NUMBER:
					score += 40.0 # Prefere queimar números altos primeiro
					score += c.number_value * 2.0
				UnoCard.CardType.SKIP, UnoCard.CardType.REVERSE:
					score += 25.0
				UnoCard.CardType.DRAW_TWO:
					score += 20.0
				UnoCard.CardType.WILD:
					score += 10.0 # Guarda o curinga
				UnoCard.CardType.WILD_DRAW_FOUR:
					score += 5.0 # Guarda o +4 para emergência

		# 2) Sinergia de cor: prioriza cartas da cor que Maria Fernanda mais possui na mão
		if c.card_color != UnoCard.CardColor.WILD:
			var count_in_hand: int = hand_color_counts.get(c.card_color, 0)
			score += count_in_hand * 12.0

			# Se o Miguel já comprou carta nessa cor, significa que ele não tem!
			if opponent_missing_colors.has(c.card_color):
				score += 35.0

		# 3) Se for a última carta da mão (bater agora)
		if hand.size() == 1:
			score += 500.0

		if score > best_score:
			best_score = score
			best_card = c

	return best_card


## Escolhe a cor mais vantajosa para declarar ao jogar Curinga ou Curinga +4
func choose_best_color(hand: Array[UnoCard]) -> UnoCard.CardColor:
	var counts := _count_hand_colors(hand)
	var best_col := UnoCard.CardColor.RED
	var best_count := -1

	# Prioriza a cor que Maria Fernanda mais tem, desempatando por fraqueza conhecida de Miguel
	for col in [UnoCard.CardColor.RED, UnoCard.CardColor.YELLOW, UnoCard.CardColor.GREEN, UnoCard.CardColor.BLUE]:
		var c: int = counts.get(col, 0)
		var bonus := 0
		if opponent_missing_colors.has(col):
			bonus += 2
		if (c + bonus) > best_count:
			best_count = c + bonus
			best_col = col

	return best_col


func _count_hand_colors(hand: Array[UnoCard]) -> Dictionary:
	var counts := {
		UnoCard.CardColor.RED: 0,
		UnoCard.CardColor.YELLOW: 0,
		UnoCard.CardColor.GREEN: 0,
		UnoCard.CardColor.BLUE: 0,
	}
	for c in hand:
		if c.card_color != UnoCard.CardColor.WILD:
			counts[c.card_color] = counts.get(c.card_color, 0) + 1
	return counts

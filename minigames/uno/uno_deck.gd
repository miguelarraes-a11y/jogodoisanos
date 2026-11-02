class_name UnoDeck
extends RefCounted
## Gerenciador do baralho oficial de UNO (108 cartas), compras e descartes.

var draw_pile: Array[UnoCard] = []
var discard_pile: Array[UnoCard] = []


func reset() -> void:
	draw_pile.clear()
	discard_pile.clear()

	var colors: Array[UnoCard.CardColor] = [
		UnoCard.CardColor.RED,
		UnoCard.CardColor.YELLOW,
		UnoCard.CardColor.GREEN,
		UnoCard.CardColor.BLUE,
	]

	for col in colors:
		# Um 0 de cada cor
		draw_pile.append(UnoCard.create(col, UnoCard.CardType.NUMBER, 0))
		# Dois de cada número de 1 a 9
		for n in range(1, 10):
			draw_pile.append(UnoCard.create(col, UnoCard.CardType.NUMBER, n))
			draw_pile.append(UnoCard.create(col, UnoCard.CardType.NUMBER, n))
		# Duas cartas de ação de cada cor
		for _i in 2:
			draw_pile.append(UnoCard.create(col, UnoCard.CardType.SKIP))
			draw_pile.append(UnoCard.create(col, UnoCard.CardType.REVERSE))
			draw_pile.append(UnoCard.create(col, UnoCard.CardType.DRAW_TWO))

	# 4 Curingas e 4 Curingas +4
	for _i in 4:
		draw_pile.append(UnoCard.create(UnoCard.CardColor.WILD, UnoCard.CardType.WILD))
		draw_pile.append(UnoCard.create(UnoCard.CardColor.WILD, UnoCard.CardType.WILD_DRAW_FOUR))

	shuffle()


func shuffle() -> void:
	draw_pile.shuffle()


func draw_card() -> UnoCard:
	if draw_pile.is_empty():
		_recycle_discard()
	if draw_pile.is_empty():
		return null
	return draw_pile.pop_back()


func _recycle_discard() -> void:
	if discard_pile.size() <= 1:
		return
	var top: UnoCard = discard_pile.pop_back()
	draw_pile.append_array(discard_pile)
	discard_pile.clear()
	discard_pile.append(top)
	shuffle()


func top_card() -> UnoCard:
	return discard_pile.back() if not discard_pile.is_empty() else null


func place_initial_card() -> UnoCard:
	while not draw_pile.is_empty():
		var c: UnoCard = draw_pile.pop_back()
		# Carta inicial não deve ser ação agressiva no início
		if c.card_type == UnoCard.CardType.NUMBER:
			discard_pile.append(c)
			return c
		else:
			draw_pile.push_front(c)
	# fallback
	var f := UnoCard.create(UnoCard.CardColor.RED, UnoCard.CardType.NUMBER, 5)
	discard_pile.append(f)
	return f

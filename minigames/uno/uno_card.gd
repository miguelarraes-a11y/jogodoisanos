class_name UnoCard
extends RefCounted
## Representação de uma carta de UNO com validações de regras.

enum CardColor { RED, YELLOW, GREEN, BLUE, WILD }
enum CardType { NUMBER, SKIP, REVERSE, DRAW_TWO, WILD, WILD_DRAW_FOUR }

var card_color: CardColor = CardColor.RED
var card_type: CardType = CardType.NUMBER
var number_value: int = 0

const COLOR_NAMES := {
	CardColor.RED: "Vermelho",
	CardColor.YELLOW: "Amarelo",
	CardColor.GREEN: "Verde",
	CardColor.BLUE: "Azul",
	CardColor.WILD: "Coringa",
}

const COLOR_VALUES := {
	CardColor.RED: Color("e53935"),
	CardColor.YELLOW: Color("fdd835"),
	CardColor.GREEN: Color("43a047"),
	CardColor.BLUE: Color("1e88e5"),
	CardColor.WILD: Color("212121"),
}


static func create(col: CardColor, type: CardType, val: int = 0) -> UnoCard:
	var c := UnoCard.new()
	c.card_color = col
	c.card_type = type
	c.number_value = val
	return c


func can_play_on(top_card: UnoCard, active_color: CardColor) -> bool:
	# Curingas podem ser jogados sobre qualquer carta
	if card_color == CardColor.WILD:
		return true
	# Mesma cor ativa
	if card_color == active_color:
		return true
	# Mesmo número
	if card_type == CardType.NUMBER and top_card.card_type == CardType.NUMBER:
		if number_value == top_card.number_value:
			return true
	# Mesmo tipo de ação (Skip com Skip, +2 com +2, etc.)
	if card_type == top_card.card_type and card_type != CardType.NUMBER:
		return true
	return false


func get_symbol() -> String:
	match card_type:
		CardType.NUMBER: return str(number_value)
		CardType.SKIP: return "BLOQ"
		CardType.REVERSE: return "<->"
		CardType.DRAW_TWO: return "+2"
		CardType.WILD: return "COR"
		CardType.WILD_DRAW_FOUR: return "+4"
	return "?"


func get_text_color() -> Color:
	if card_color == CardColor.YELLOW:
		return Color("1a1a1a")
	return Color.WHITE


func get_name() -> String:
	var col_str: String = COLOR_NAMES[card_color]
	match card_type:
		CardType.NUMBER: return "%s %d" % [col_str, number_value]
		CardType.SKIP: return "Bloqueio %s" % col_str
		CardType.REVERSE: return "Inverter %s" % col_str
		CardType.DRAW_TWO: return "+2 %s" % col_str
		CardType.WILD: return "Curinga (Mudar Cor)"
		CardType.WILD_DRAW_FOUR: return "Curinga +4"
	return ""

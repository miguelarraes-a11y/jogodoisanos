class_name UnoMinigame
extends MiniGameBase
## Minigame oficial de UNO pelo celular.
## Miguel (Jogador) vs Maria Fernanda (Bot com IA estratégica e desafiadora).

var deck: UnoDeck
var ai: UnoAI

var player_hand: Array[UnoCard] = []
var maria_hand: Array[UnoCard] = []

var active_color: UnoCard.CardColor = UnoCard.CardColor.RED
var is_player_turn: bool = true
var is_game_over: bool = false
var winner: String = ""

# Nós da Interface
var table_root: Control
var maria_cards_container: HBoxContainer
var player_cards_container: HBoxContainer
var player_cards_scroll: ScrollContainer
var discard_visual: Panel
var discard_symbol: Label
var color_indicator: ColorRect
var color_name_lbl: Label
var turn_label: Label
var draw_btn: Button
var uno_btn: Button
var color_picker_layer: Control

var selected_index: int = 0
var player_called_uno: bool = false


func _intro() -> Dictionary:
	return {
		"title": "UNO PELO CELULAR",
		"lines": [
			"Partida de UNO com Maria Fernanda pelo celular.",
			"Setas / Mouse : navegar e selecionar cartas",
			"Espaço / Enter / Clique : jogar carta selecionada",
			"C ou Clique : comprar carta do baralho",
			"U ou Clique : declarar UNO quando tiver 1 carta",
			"Dica: Cartas que combinam ficam destacadas em dourado!",
		],
		"hint": "[%s] Iniciar Partida" % InputConfig.label_for("confirm"),
	}


func _results(result: Dictionary) -> Dictionary:
	var win: String = result.get("winner", "maria")
	var title := "VITÓRIA!" if win == "miguel" else "MARIA FERNANDA VENCEU!"
	var line1 := "Você conseguiu vencer a partida de UNO!" if win == "miguel" else "Maria Fernanda jogou de forma impecável e venceu."
	return {
		"title": title,
		"lines": [line1, "Muitas risadas e cartas trocadas pelo celular."],
		"hint": "[%s] Continuar a história" % InputConfig.label_for("confirm"),
	}


func _play() -> Dictionary:
	deck = UnoDeck.new()
	deck.reset()
	ai = UnoAI.new()

	_build_board()

	# Distribui 7 cartas para cada
	for _i in 7:
		player_hand.append(deck.draw_card())
		maria_hand.append(deck.draw_card())

	var top := deck.place_initial_card()
	active_color = top.card_color

	_update_ui()
	AudioManager.play_sfx("card_draw", -3.0)

	is_player_turn = true
	is_game_over = false

	while not is_game_over:
		if is_player_turn:
			_check_player_playable_state()
			_highlight_selected_card()
			await _player_turn_step()
		else:
			turn_label.text = "Vez de Maria Fernanda..."
			await _maria_turn_step()

		# Checa fim de jogo
		if player_hand.is_empty():
			winner = "miguel"
			is_game_over = true
		elif maria_hand.is_empty():
			winner = "maria"
			is_game_over = true

	await get_tree().create_timer(1.0).timeout
	return {"winner": winner}


func _build_board() -> void:
	table_root = Control.new()
	table_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	layer.add_child(table_root)

	# Fundo da mesa de cartas no celular
	var bg := ColorRect.new()
	bg.set_anchors_preset(Control.PRESET_FULL_RECT)
	bg.color = Color("1a2634")
	table_root.add_child(bg)

	# Mão de Maria Fernanda (topo)
	maria_cards_container = HBoxContainer.new()
	maria_cards_container.position = Vector2(8, 4)
	maria_cards_container.size = Vector2(304, 28)
	maria_cards_container.alignment = BoxContainer.ALIGNMENT_CENTER
	maria_cards_container.add_theme_constant_override("separation", 2)
	table_root.add_child(maria_cards_container)

	# Pilha de descarte (centro)
	discard_visual = Panel.new()
	discard_visual.position = Vector2(142, 46)
	discard_visual.size = Vector2(36, 48)
	table_root.add_child(discard_visual)

	discard_symbol = Label.new()
	discard_symbol.set_anchors_preset(Control.PRESET_FULL_RECT)
	discard_symbol.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	discard_symbol.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	discard_symbol.add_theme_font_size_override("font_size", 20)
	discard_visual.add_child(discard_symbol)

	# Indicador de cor ativa
	var col_box := HBoxContainer.new()
	col_box.position = Vector2(8, 42)
	col_box.add_theme_constant_override("separation", 4)
	table_root.add_child(col_box)

	var col_txt := Label.new()
	col_txt.text = "Cor:"
	col_txt.add_theme_font_size_override("font_size", 16)
	col_txt.add_theme_color_override("font_color", Color("ffd54f"))
	col_box.add_child(col_txt)

	color_indicator = ColorRect.new()
	color_indicator.custom_minimum_size = Vector2(16, 16)
	col_box.add_child(color_indicator)

	color_name_lbl = Label.new()
	color_name_lbl.add_theme_font_size_override("font_size", 16)
	color_name_lbl.add_theme_color_override("font_color", Color.WHITE)
	col_box.add_child(color_name_lbl)

	# Turn banner
	turn_label = Label.new()
	turn_label.position = Vector2(8, 64)
	turn_label.size = Vector2(128, 36)
	turn_label.add_theme_font_size_override("font_size", 14)
	turn_label.add_theme_color_override("font_color", Color("ffffff"))
	turn_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	table_root.add_child(turn_label)

	# Botão de compra / baralho
	draw_btn = Button.new()
	draw_btn.text = "Comprar [C]"
	draw_btn.position = Vector2(188, 46)
	draw_btn.size = Vector2(62, 30)
	draw_btn.add_theme_font_size_override("font_size", 14)
	var st := StyleBoxFlat.new()
	st.bg_color = Color("37474f")
	st.border_color = Color("78909c")
	st.set_border_width_all(1)
	st.set_corner_radius_all(3)
	draw_btn.add_theme_stylebox_override("normal", st)
	draw_btn.pressed.connect(_on_player_draw_pressed)
	table_root.add_child(draw_btn)

	# Botão UNO
	uno_btn = Button.new()
	uno_btn.text = "UNO! [U]"
	uno_btn.position = Vector2(254, 46)
	uno_btn.size = Vector2(58, 30)
	uno_btn.add_theme_font_size_override("font_size", 14)
	var uno_st := StyleBoxFlat.new()
	uno_st.bg_color = Color("d32f2f")
	uno_st.border_color = Color("ff5252")
	uno_st.set_border_width_all(1)
	uno_st.set_corner_radius_all(3)
	uno_btn.add_theme_stylebox_override("normal", uno_st)
	uno_btn.pressed.connect(_on_uno_button_pressed)
	table_root.add_child(uno_btn)

	# Scroll Container para a mão de Miguel
	player_cards_scroll = ScrollContainer.new()
	player_cards_scroll.position = Vector2(6, 110)
	player_cards_scroll.size = Vector2(308, 66)
	player_cards_scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	table_root.add_child(player_cards_scroll)

	player_cards_container = HBoxContainer.new()
	player_cards_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	player_cards_container.add_theme_constant_override("separation", 3)
	player_cards_scroll.add_child(player_cards_container)

	# Modal de escolha de cor para o Curinga
	_build_color_picker()


func _build_color_picker() -> void:
	color_picker_layer = Control.new()
	color_picker_layer.set_anchors_preset(Control.PRESET_FULL_RECT)
	color_picker_layer.visible = false
	table_root.add_child(color_picker_layer)

	var dimmer := ColorRect.new()
	dimmer.set_anchors_preset(Control.PRESET_FULL_RECT)
	dimmer.color = Color(0, 0, 0, 0.65)
	color_picker_layer.add_child(dimmer)

	var panel := Panel.new()
	panel.position = Vector2(55, 35)
	panel.size = Vector2(210, 110)
	var p_st := StyleBoxFlat.new()
	p_st.bg_color = Color("212121")
	p_st.border_color = Color("ffd54f")
	p_st.set_border_width_all(2)
	p_st.set_corner_radius_all(6)
	panel.add_theme_stylebox_override("panel", p_st)
	color_picker_layer.add_child(panel)

	var title := Label.new()
	title.text = "ESCOLHA A NOVA COR:"
	title.position = Vector2(0, 8)
	title.size = Vector2(210, 20)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 16)
	title.add_theme_color_override("font_color", Color("ffd54f"))
	panel.add_child(title)

	var grid := GridContainer.new()
	grid.columns = 2
	grid.position = Vector2(15, 34)
	grid.add_theme_constant_override("h_separation", 8)
	grid.add_theme_constant_override("v_separation", 6)
	panel.add_child(grid)

	var color_options: Array = [
		{"col": UnoCard.CardColor.RED, "label": "[1] Vermelho", "bg": Color("e53935"), "fg": Color.WHITE},
		{"col": UnoCard.CardColor.YELLOW, "label": "[2] Amarelo", "bg": Color("fdd835"), "fg": Color("1a1a1a")},
		{"col": UnoCard.CardColor.GREEN, "label": "[3] Verde", "bg": Color("43a047"), "fg": Color.WHITE},
		{"col": UnoCard.CardColor.BLUE, "label": "[4] Azul", "bg": Color("1e88e5"), "fg": Color.WHITE},
	]

	for opt in color_options:
		var btn := Button.new()
		btn.text = opt["label"]
		btn.custom_minimum_size = Vector2(86, 28)
		btn.add_theme_font_size_override("font_size", 15)
		btn.add_theme_color_override("font_color", opt["fg"])
		var b_st := StyleBoxFlat.new()
		b_st.bg_color = opt["bg"]
		b_st.set_corner_radius_all(3)
		btn.add_theme_stylebox_override("normal", b_st)
		btn.pressed.connect(_on_color_chosen.bind(opt["col"]))
		grid.add_child(btn)


var _chosen_color: UnoCard.CardColor = UnoCard.CardColor.RED
var _waiting_color: bool = false

func _on_color_chosen(col: UnoCard.CardColor) -> void:
	_chosen_color = col
	_waiting_color = false
	color_picker_layer.visible = false


func _on_uno_button_pressed() -> void:
	player_called_uno = true
	AudioManager.play_sfx("uno_alert", -2.0)
	uno_btn.text = "UNO! ✓"
	uno_btn.modulate = Color(1, 1, 0)
	turn_label.text = "Você declarou UNO!"


var _player_action_done: bool = false

func _player_turn_step() -> void:
	_player_action_done = false
	while not _player_action_done and not is_game_over:
		if _waiting_color:
			if Input.is_key_pressed(KEY_1): _on_color_chosen(UnoCard.CardColor.RED)
			elif Input.is_key_pressed(KEY_2): _on_color_chosen(UnoCard.CardColor.YELLOW)
			elif Input.is_key_pressed(KEY_3): _on_color_chosen(UnoCard.CardColor.GREEN)
			elif Input.is_key_pressed(KEY_4): _on_color_chosen(UnoCard.CardColor.BLUE)
		await get_tree().process_frame


func _maria_turn_step() -> void:
	await get_tree().create_timer(randf_range(1.0, 1.4)).timeout
	if is_game_over:
		return

	var top := deck.top_card()
	var card_to_play: UnoCard = ai.choose_card(maria_hand, top, active_color, player_hand.size())

	if card_to_play != null:
		maria_hand.erase(card_to_play)
		deck.discard_pile.append(card_to_play)
		AudioManager.play_sfx("card_play", -3.0)

		if maria_hand.size() == 1:
			AudioManager.play_sfx("uno_alert", -2.0)
			turn_label.text = "Maria Fernanda gritou UNO!"

		var skipped := false
		if card_to_play.card_color == UnoCard.CardColor.WILD:
			active_color = ai.choose_best_color(maria_hand)
			if card_to_play.card_type == UnoCard.CardType.WILD_DRAW_FOUR:
				for _i in 4: player_hand.append(deck.draw_card())
				turn_label.text = "Maria jogou +4! Você comprou 4 cartas."
				skipped = true
		else:
			active_color = card_to_play.card_color
			if card_to_play.card_type == UnoCard.CardType.DRAW_TWO:
				for _i in 2: player_hand.append(deck.draw_card())
				turn_label.text = "Maria jogou +2! Você comprou 2 cartas."
				skipped = true
			elif card_to_play.card_type == UnoCard.CardType.SKIP:
				turn_label.text = "Maria jogou Bloqueio! Seu turno pulado."
				skipped = true
			elif card_to_play.card_type == UnoCard.CardType.REVERSE:
				turn_label.text = "Maria jogou Inverter!"
				skipped = true

		ai.record_opponent_played(active_color)
		_update_ui()

		if not skipped:
			is_player_turn = true
	else:
		var drawn := deck.draw_card()
		if drawn != null:
			maria_hand.append(drawn)
			AudioManager.play_sfx("card_draw", -4.0)
			turn_label.text = "Maria Fernanda comprou uma carta."
			if drawn.can_play_on(top, active_color):
				await get_tree().create_timer(0.6).timeout
				maria_hand.erase(drawn)
				deck.discard_pile.append(drawn)
				active_color = ai.choose_best_color(maria_hand) if drawn.card_color == UnoCard.CardColor.WILD else drawn.card_color
				AudioManager.play_sfx("card_play", -3.0)
		_update_ui()
		is_player_turn = true


func _check_player_playable_state() -> void:
	var top := deck.top_card()
	var has_playable := false
	for c in player_hand:
		if c.can_play_on(top, active_color):
			has_playable = true
			break

	if not has_playable:
		turn_label.text = "Sem cartas válidas! Compre uma carta [C]."
		var st := StyleBoxFlat.new()
		st.bg_color = Color("2e7d32")
		st.border_color = Color("ffd54f")
		st.set_border_width_all(2)
		st.set_corner_radius_all(3)
		draw_btn.add_theme_stylebox_override("normal", st)
	else:
		turn_label.text = "Sua vez! Escolha uma carta destacada."
		var st := StyleBoxFlat.new()
		st.bg_color = Color("37474f")
		st.border_color = Color("78909c")
		st.set_border_width_all(1)
		st.set_corner_radius_all(3)
		draw_btn.add_theme_stylebox_override("normal", st)


func _on_player_draw_pressed() -> void:
	if not is_player_turn or is_game_over:
		return
	ai.record_opponent_drew(active_color)
	var c := deck.draw_card()
	if c != null:
		player_hand.append(c)
		AudioManager.play_sfx("card_draw", -3.0)
		turn_label.text = "Você comprou uma carta."

	selected_index = mini(selected_index, maxi(0, player_hand.size() - 1))
	_update_ui()
	is_player_turn = false
	_player_action_done = true


func _try_play_player_card(card: UnoCard) -> void:
	if not is_player_turn or is_game_over:
		return
	var top := deck.top_card()
	if not card.can_play_on(top, active_color):
		AudioManager.play_sfx("phone_click", -6.0)
		var col_name: String = UnoCard.COLOR_NAMES.get(active_color, "Cor atual")
		turn_label.text = "Não combina! Use cor %s ou %s." % [col_name, top.get_symbol()]
		return

	player_hand.erase(card)
	deck.discard_pile.append(card)
	AudioManager.play_sfx("card_play", -3.0)

	var skipped := false
	if card.card_color == UnoCard.CardColor.WILD:
		_waiting_color = true
		color_picker_layer.visible = true
		while _waiting_color:
			await get_tree().process_frame
		active_color = _chosen_color
		if card.card_type == UnoCard.CardType.WILD_DRAW_FOUR:
			for _i in 4: maria_hand.append(deck.draw_card())
			turn_label.text = "Você jogou +4! Maria comprou 4 cartas."
			skipped = true
	else:
		active_color = card.card_color
		if card.card_type == UnoCard.CardType.DRAW_TWO:
			for _i in 2: maria_hand.append(deck.draw_card())
			turn_label.text = "Você jogou +2! Maria comprou 2 cartas."
			skipped = true
		elif card.card_type == UnoCard.CardType.SKIP:
			turn_label.text = "Você jogou Bloqueio! Turno de Maria pulado."
			skipped = true
		elif card.card_type == UnoCard.CardType.REVERSE:
			turn_label.text = "Você inverteu o sentido!"
			skipped = true

	# Alerta se ficou com 1 carta
	if player_hand.size() == 1:
		player_called_uno = true
		turn_label.text = "Última carta! Declarou UNO!"
		AudioManager.play_sfx("uno_alert", -2.0)

	player_called_uno = false
	uno_btn.text = "UNO! [U]"
	uno_btn.modulate = Color.WHITE

	selected_index = maxi(0, mini(selected_index, player_hand.size() - 1))
	_update_ui()

	if not skipped:
		is_player_turn = false
	_player_action_done = true


func _update_ui() -> void:
	var top := deck.top_card()
	if top != null:
		var st := StyleBoxFlat.new()
		st.bg_color = UnoCard.COLOR_VALUES[active_color]
		st.set_corner_radius_all(3)
		discard_visual.add_theme_stylebox_override("panel", st)
		discard_symbol.text = top.get_symbol()
		discard_symbol.add_theme_color_override("font_color", top.get_text_color())

	color_indicator.color = UnoCard.COLOR_VALUES[active_color]
	color_name_lbl.text = UnoCard.COLOR_NAMES.get(active_color, "")

	# Remove nós antigos de Maria Fernanda imediatamente
	for child in maria_cards_container.get_children():
		maria_cards_container.remove_child(child)
		child.queue_free()

	var mf_label := Label.new()
	mf_label.text = "Maria Fernanda (%d cartas):" % maria_hand.size()
	mf_label.add_theme_font_size_override("font_size", 16)
	mf_label.add_theme_color_override("font_color", Color("ffd54f"))
	maria_cards_container.add_child(mf_label)

	for i in mini(maria_hand.size(), 8):
		var card_back := Panel.new()
		card_back.custom_minimum_size = Vector2(16, 24)
		var b_st := StyleBoxFlat.new()
		b_st.bg_color = Color("212121")
		b_st.border_color = Color("d32f2f")
		b_st.set_border_width_all(1)
		b_st.set_corner_radius_all(2)
		card_back.add_theme_stylebox_override("panel", b_st)
		maria_cards_container.add_child(card_back)

	# Remove nós antigos do jogador imediatamente
	for child in player_cards_container.get_children():
		player_cards_container.remove_child(child)
		child.queue_free()

	for i in player_hand.size():
		var c: UnoCard = player_hand[i]
		var can_play: bool = c.can_play_on(top, active_color) if top != null else true

		var btn := Button.new()
		btn.text = c.get_symbol()
		btn.custom_minimum_size = Vector2(26, 42)
		btn.add_theme_font_size_override("font_size", 16)
		btn.add_theme_color_override("font_color", c.get_text_color())

		var c_st := StyleBoxFlat.new()
		c_st.bg_color = UnoCard.COLOR_VALUES[c.card_color]
		c_st.set_corner_radius_all(3)

		if i == selected_index:
			c_st.border_color = Color.WHITE
			c_st.set_border_width_all(2)
		elif can_play:
			c_st.border_color = Color("ffd54f")
			c_st.set_border_width_all(1)

		btn.add_theme_stylebox_override("normal", c_st)
		btn.add_theme_stylebox_override("hover", c_st)
		btn.add_theme_stylebox_override("pressed", c_st)

		if not can_play and is_player_turn:
			btn.modulate = Color(1.0, 1.0, 1.0, 0.6)
		else:
			btn.modulate = Color.WHITE

		btn.pressed.connect(func():
			selected_index = i
			_try_play_player_card(c)
		)
		player_cards_container.add_child(btn)


func _highlight_selected_card() -> void:
	var children := player_cards_container.get_children()
	var top := deck.top_card()
	var max_count := mini(children.size(), player_hand.size())
	for i in max_count:
		if children[i] is Button:
			var btn := children[i] as Button
			var c: UnoCard = player_hand[i]
			var can_play: bool = c.can_play_on(top, active_color) if top != null else true
			var c_st := StyleBoxFlat.new()
			c_st.bg_color = UnoCard.COLOR_VALUES[c.card_color]
			c_st.set_corner_radius_all(3)
			if i == selected_index:
				c_st.border_color = Color.WHITE
				c_st.set_border_width_all(2)
			elif can_play:
				c_st.border_color = Color("ffd54f")
				c_st.set_border_width_all(1)
			btn.add_theme_stylebox_override("normal", c_st)


func _unhandled_input(event: InputEvent) -> void:
	if not is_player_turn or is_game_over or player_hand.is_empty():
		return
	if event.is_action_pressed("move_left"):
		selected_index = maxi(0, selected_index - 1)
		_highlight_selected_card()
		_ensure_card_visible(selected_index)
	elif event.is_action_pressed("move_right"):
		selected_index = mini(player_hand.size() - 1, selected_index + 1)
		_highlight_selected_card()
		_ensure_card_visible(selected_index)
	elif event.is_action_pressed("confirm") or event.is_action_pressed("interact"):
		if selected_index >= 0 and selected_index < player_hand.size():
			_try_play_player_card(player_hand[selected_index])
	elif event is InputEventKey and event.pressed:
		if event.keycode == KEY_C:
			_on_player_draw_pressed()
		elif event.keycode == KEY_U:
			_on_uno_button_pressed()


func _ensure_card_visible(idx: int) -> void:
	if player_cards_scroll != null:
		var card_w := 29.0
		player_cards_scroll.scroll_horizontal = int(idx * card_w - 100.0)

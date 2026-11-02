extends Node2D
## Cenário de TESTE da Etapa 2: rua residencial brasileira provisória.
## Serve para validar movimentação, colisões, câmera, interação e caixa de diálogo.
## Tab troca o personagem controlado (só nesta cena de teste).

const WORLD := StreetBuilder.WORLD

var world: Node2D
var camera: FollowCamera
var players: Array = []
var current: int = 0


func _ready() -> void:
	world = Node2D.new()
	world.y_sort_enabled = true
	add_child(world)
	StreetBuilder.build(self, world)
	_spawn_characters()
	add_child(DialogueBox.new())
	_build_camera()
	_build_hint()


func _spawn(id: String, pos: Vector2, dialogue: Array = []) -> Character:
	var c := Character.new()
	c.character_id = id
	c.position = pos
	world.add_child(c)
	if not dialogue.is_empty():
		c.add_child(Interactable.create(Vector2(0, -8), 14.0, dialogue))
	return c


func _spawn_characters() -> void:
	players = [
		_spawn("miguel", Vector2(236, 600)),
		_spawn("maria_fernanda", Vector2(256, 600)),
		_spawn("ana_clara", Vector2(228, 540), ["dev_ana", "dev_ana_2"]),
		_spawn("gabriele", Vector2(258, 540), ["dev_gabriele"]),
	]
	_spawn("morador", Vector2(166, 284), ["dev_morador"])
	_spawn("crianca", Vector2(262, 400), ["dev_crianca"])
	players[0].set_player(true)


func _build_camera() -> void:
	camera = FollowCamera.new()
	camera.target = players[0]
	add_child(camera)
	camera.set_world_limits(WORLD)
	camera.make_current()
	camera.snap_to_target()


func _build_hint() -> void:
	var layer := CanvasLayer.new()
	layer.layer = 5
	add_child(layer)
	var label := Label.new()
	label.text = "Setas/WASD: andar   Shift: correr\nE/Enter: interagir   Tab: trocar personagem (teste)"
	label.position = Vector2(4, 2)
	label.add_theme_font_size_override("font_size", 8)
	label.add_theme_color_override("font_color", Color.WHITE)
	label.add_theme_color_override("font_outline_color", Color.BLACK)
	label.add_theme_constant_override("outline_size", 3)
	layer.add_child(label)


func _unhandled_input(event: InputEvent) -> void:
	if GameState.controls_locked:
		return
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_TAB:
		players[current].set_player(false)
		current = (current + 1) % players.size()
		players[current].set_player(true)
		camera.target = players[current]

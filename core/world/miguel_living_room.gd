class_name MiguelLivingRoom
extends Node2D
## Sala de estar da casa de Miguel (320x180).
## Ambiente acolhedor de residência brasileira:
## Sofá, rack de TV, caminha dos pets, janela com cortina e porta.
## Contém os dois animais: Bulldog preto e Gato cinza.

const WIDTH := 320
const HEIGHT := 180

var world: Node2D
var light: CanvasModulate
var bulldog: Character
var cat: Character
var miguel: Character


func _init() -> void:
	name = "MiguelLivingRoom"


func _ready() -> void:
	_build_room()


func _build_room() -> void:
	# Piso de cerâmica residencial
	PropFactory.make_ground(self, "floor_ceramic", Rect2(0, 0, WIDTH, HEIGHT), -3)

	# Parede acolhedora
	PropFactory.make_ground(self, "wall_miguel", Rect2(0, 0, WIDTH, 54), -2)

	# Rodapé
	PropFactory.make_ground(self, "baseboard", Rect2(0, 52, WIDTH, 4), -1)

	# Iluminação ambiente
	light = CanvasModulate.new()
	light.color = Color(1.0, 0.96, 0.90) # luz natural acolhedora
	add_child(light)

	# Mundo com Y-Sort habilitado para profundidade dos personagens e móveis
	world = Node2D.new()
	world.name = "World"
	world.y_sort_enabled = true
	add_child(world)

	# Janela com cortina e porta de madeira
	PropFactory.make_prop(world, "window_curtain", Vector2(70, 42))
	PropFactory.make_prop(world, "window_curtain", Vector2(250, 42))
	PropFactory.make_prop(world, "door_wood", Vector2(295, 52), Vector2(16, 28))

	# Rack da TV (na parede esquerda)
	PropFactory.make_prop(world, "tv_rack", Vector2(56, 88), Vector2(36, 18))

	# Sofá confortável de Miguel (centro-direita)
	PropFactory.make_prop(world, "sofa", Vector2(170, 106), Vector2(48, 22))

	# Caminha do pet
	PropFactory.make_prop(world, "pet_bed", Vector2(240, 126), Vector2(22, 16))

	# Bulldog preto descansando próximo à caminha
	bulldog = Character.new()
	bulldog.character_id = "bulldog"
	bulldog.position = Vector2(238, 122)
	world.add_child(bulldog)
	bulldog.sprite.play("idle_down")
	_add_pet_breathing(bulldog)

	# Gato cinza relaxando perto do sofá
	cat = Character.new()
	cat.character_id = "gato_cinza"
	cat.position = Vector2(130, 108)
	world.add_child(cat)
	cat.sprite.play("idle_right")
	_add_pet_breathing(cat)


func spawn_miguel(pos: Vector2 = Vector2(170, 102)) -> Character:
	miguel = Character.new()
	miguel.character_id = "miguel"
	miguel.position = pos
	world.add_child(miguel)
	miguel.sprite.play("idle_down")
	return miguel


func _add_pet_breathing(pet: Character) -> void:
	# Animação sutil de respiração
	var tw := pet.create_tween().set_loops()
	tw.tween_property(pet.sprite, "scale:y", 1.05, 1.4).set_trans(Tween.TRANS_SINE)
	tw.tween_property(pet.sprite, "scale:y", 1.0, 1.4).set_trans(Tween.TRANS_SINE)

class_name FamilyNpc
extends Character
## Representação de personagens familiares (provisórios e configuráveis).
## Permite definir facilmente id visual, nome de exibição e falas.

@export var role_title: String = "Familiar"


func _init(id: String = "family_member_a", title: String = "Familiar") -> void:
	character_id = id
	role_title = title

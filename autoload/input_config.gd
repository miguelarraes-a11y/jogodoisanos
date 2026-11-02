extends Node
## Registra as ações de entrada em código, para os controles serem configuráveis.

const DEFAULTS: Dictionary = {
	"move_up": [KEY_W, KEY_UP],
	"move_down": [KEY_S, KEY_DOWN],
	"move_left": [KEY_A, KEY_LEFT],
	"move_right": [KEY_D, KEY_RIGHT],
	"run": [KEY_SHIFT],
	"interact": [KEY_E, KEY_ENTER],
	"confirm": [KEY_SPACE],
	"cancel": [KEY_ESCAPE],
	"aim_left": [KEY_A, KEY_LEFT],
	"aim_right": [KEY_D, KEY_RIGHT],
	"shoot": [KEY_SPACE],
}


func _ready() -> void:
	reset_to_defaults()


func reset_to_defaults() -> void:
	for action in DEFAULTS:
		bind(action, DEFAULTS[action])


## Substitui as teclas de uma ação. Usado pela tela de configurações (etapa futura).
func bind(action: String, keycodes: Array) -> void:
	if InputMap.has_action(action):
		InputMap.action_erase_events(action)
	else:
		InputMap.add_action(action)
	for k in keycodes:
		var ev := InputEventKey.new()
		ev.physical_keycode = k
		InputMap.action_add_event(action, ev)


const LABELS := {"Space": "Espaço", "Escape": "Esc", "Left": "Seta esq.", "Right": "Seta dir."}


## Nome da primeira tecla ligada à ação (para mostrar nas instruções).
func label_for(action: String) -> String:
	if InputMap.has_action(action):
		for ev in InputMap.action_get_events(action):
			if ev is InputEventKey:
				var name := OS.get_keycode_string(ev.physical_keycode)
				return LABELS.get(name, name)
	return "?"

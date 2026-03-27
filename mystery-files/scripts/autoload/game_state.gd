extends Node
class_name GameStateMachine

# ===========================================================
# Game State Machine - Manages global game states
# ===========================================================

enum State {
	MENU,       # Main menu
	EXPLORE,    # Exploration scene
	DIALOGUE,   # Dialogue scene
	ENDING,     # Ending/Result scene
	ARCHIVE,    # Archive/History scene
	SETTINGS,   # Settings scene
	LOADING     # Loading scene
}

# Signals
signal state_changed(from_state: State, to_state: State)
signal scene_request(scene_path: String)

# State variables
var current_state: State = State.MENU
var previous_state: State = State.MENU
var state_history: Array[State] = []

# State transition rules (which states can transition to which)
var transition_rules: Dictionary = {
	State.MENU: [State.EXPLORE, State.ARCHIVE, State.SETTINGS, State.LOADING],
	State.EXPLORE: [State.DIALOGUE, State.MENU, State.ARCHIVE, State.LOADING],
	State.DIALOGUE: [State.EXPLORE, State.ENDING, State.LOADING],
	State.ENDING: [State.ARCHIVE, State.MENU, State.EXPLORE],
	State.ARCHIVE: [State.MENU, State.EXPLORE],
	State.SETTINGS: [State.MENU, State.EXPLORE, State.DIALOGUE],
	State.LOADING: [State.MENU, State.EXPLORE, State.DIALOGUE, State.ENDING, State.ARCHIVE]
}


func _ready() -> void:
	print("[GameState] Initialized")


# Change to a new state
func change_state(new_state: State) -> void:
	if current_state == new_state:
		return

	if not _can_transition(current_state, new_state):
		push_warning("[GameState] Invalid transition from %s to %s" % [State.keys()[current_state], State.keys()[new_state]])
		return

	previous_state = current_state
	state_history.append(current_state)
	current_state = new_state

	print("[GameState] Changed: %s -> %s" % [State.keys()[previous_state], State.keys()[current_state]])

	# Emit signals
	state_changed.emit(previous_state, new_state)
	EventBus.emit_game_state_changed(previous_state, new_state)


# Check if transition is allowed
func _can_transition(from: State, to: State) -> bool:
	if from not in transition_rules:
		return false
	return to in transition_rules[from]


# Query methods
func is_in_game() -> bool:
	return current_state in [State.EXPLORE, State.DIALOGUE]


func is_in_menu() -> bool:
	return current_state == State.MENU


func is_in_dialogue() -> bool:
	return current_state == State.DIALOGUE


func is_in_exploring() -> bool:
	return current_state == State.EXPLORE


func get_current_state() -> State:
	return current_state


func get_previous_state() -> State:
	return previous_state


# Navigation helpers
func back_to_previous() -> void:
	if state_history.size() > 0:
		var prev = state_history.pop_back()
		change_state(prev)


func go_to_menu() -> void:
	change_state(State.MENU)
	scene_request.emit("res://scenes/ui/main_menu.tscn")


func go_to_explore() -> void:
	change_state(State.EXPLORE)
	scene_request.emit("res://scenes/ui/explore.tscn")


func go_to_dialogue() -> void:
	change_state(State.DIALOGUE)
	scene_request.emit("res://scenes/ui/dialogue.tscn")


func go_to_ending() -> void:
	change_state(State.ENDING)
	scene_request.emit("res://scenes/ui/ending.tscn")


func go_to_archive() -> void:
	change_state(State.ARCHIVE)
	scene_request.emit("res://scenes/ui/archive.tscn")


func go_to_settings() -> void:
	change_state(State.SETTINGS)
	scene_request.emit("res://scenes/ui/settings.tscn")

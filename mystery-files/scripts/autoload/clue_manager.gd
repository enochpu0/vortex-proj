extends Node
class_name ClueManagerClass

# ===========================================================
# Clue Manager - Manages clue collection and tracking
# ===========================================================

# Signals
signal clue_registered(clue_id: String)
signal clue_collected(clue_id: String)
signal clue_examined(clue_id: String)
signal all_clues_collected()

# Clue database
var clue_database: Dictionary = {}

# Collected clues
var collected_clues: Array[String] = []

# Examined clues (player has looked at details)
var examined_clues: Array[String] = []


func _ready() -> void:
	print("[ClueManager] Initialized")


# Register a clue
func register_clue(clue_data: Dictionary) -> void:
	var clue_id = clue_data.get("id")
	if clue_id:
		clue_database[clue_id] = clue_data
		clue_registered.emit(clue_id)


# Register multiple clues
func register_clues(clues: Array) -> void:
	for clue in clues:
		register_clue(clue)


# Load clues from story
func load_clues_from_story(story_data: Dictionary) -> void:
	var clues = story_data.get("clues", [])
	register_clues(clues)


# Collect a clue
func collect_clue(clue_id: String) -> void:
	if clue_id not in collected_clues:
		collected_clues.append(clue_id)
		EventBus.emit_clue_collected(clue_id)
		clue_collected.emit(clue_id)

		# Check if all clues collected
		if collected_clues.size() >= clue_database.size():
			all_clues_collected.emit()


# Examine a clue (view details)
func examine_clue(clue_id: String) -> Dictionary:
	if clue_id not in examined_clues:
		examined_clues.append(clue_id)
		clue_examined.emit(clue_id)

	return get_clue(clue_id)


# Get clue data
func get_clue(clue_id: String) -> Dictionary:
	return clue_database.get(clue_id, {})


# Check if clue is collected
func is_clue_collected(clue_id: String) -> bool:
	return clue_id in collected_clues


# Check if clue is examined
func is_clue_examined(clue_id: String) -> bool:
	return clue_id in examined_clues


# Get all clues
func get_all_clues() -> Array:
	return clue_database.values()


# Get collected clues
func get_collected_clues() -> Array:
	var result = []
	for clue_id in collected_clues:
		if clue_id in clue_database:
			result.append(clue_database[clue_id])
	return result


# Get missing clues
func get_missing_clues() -> Array:
	var result = []
	for clue_id in clue_database:
		if clue_id not in collected_clues:
			result.append(clue_database[clue_id])
	return result


# Get collection progress
func get_progress() -> Dictionary:
	var total = clue_database.size()
	var collected = collected_clues.size()
	return {
		"total": total,
		"collected": collected,
		"missing": total - collected,
		"percentage": int((float(collected) / total) * 100) if total > 0 else 0
	}


# Reset for new game
func reset() -> void:
	collected_clues.clear()
	examined_clues.clear()

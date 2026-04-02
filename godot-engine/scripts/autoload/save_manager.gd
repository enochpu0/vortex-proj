extends Node
class_name SaveManagerClass

# ===========================================================
# Save Manager - Manages game saves and settings
# ===========================================================

# Signals
signal game_saved(save_path: String)
signal game_loaded(save_path: String)
signal save_error(error: String)
signal settings_changed(key: String, value: Variant)

# Save paths
var save_dir: String = "user://saves/"
var current_save_path: String = "user://saves/current_save.cfg"
var history_path: String = "user://saves/history.json"
var settings_path: String = "user://saves/settings.cfg"

# Settings cache
var settings: Dictionary = {
	"bgm_volume": 0.0,
	"sfx_volume": 0.0,
	"ambient_volume": 0.0,
	"language": "zh",
	"voice_enabled": true,
	"pixel_rendering": true,
	"dialogue_speed": 1.0
}

# History cache
var game_history: Array = []


func _ready() -> void:
	_ensure_save_dir()
	load_settings()
	load_history()
	print("[SaveManager] Initialized")


# Ensure save directory exists
func _ensure_save_dir() -> void:
	var dir = DirAccess.open("user://")
	if dir:
		if not dir.dir_exists("saves"):
			dir.make_dir("saves")


# Save current game
func save_game() -> void:
	var config = ConfigFile.new()

	# Story data
	var story = StoryManager.get_current_story()
	config.set_value("story", "id", story.get("id", ""))
	config.set_value("story", "title", story.get("title", ""))
	config.set_value("story", "chapter", StoryManager.current_chapter)
	config.set_value("story", "progress", var_to_json(StoryManager.story_progress))

	# Stats
	config.set_value("stats", "total_dialogues", StoryManager.stats.get("total_dialogues", 0))
	config.set_value("stats", "correct_guesses", StoryManager.stats.get("correct_guesses", 0))
	config.set_value("stats", "play_time", StoryManager.story_progress.get("play_time", 0.0))

	# Clues
	config.set_value("clues", "collected", StoryManager.story_progress.get("collected_clues", []))

	# Save to file
	var err = config.save(current_save_path)
	if err == OK:
		game_saved.emit(current_save_path)
		print("[SaveManager] Game saved: %s" % current_save_path)
	else:
		save_error.emit("Failed to save: %d" % err)
		push_error("[SaveManager] Save failed with error: %d" % err)


# Load game
func load_game() -> Dictionary:
	var config = ConfigFile.new()
	var err = config.load(current_save_path)

	if err != OK:
		print("[SaveManager] No save file found")
		return {}

	# Load story data
	var story_id = config.get_value("story", "id", "")
	var story_title = config.get_value("story", "title", "")
	var chapter = config.get_value("story", "chapter", 1)
	var progress = json_to_var(config.get_value("story", "progress", "{}"))

	# Load stats
	StoryManager.stats["total_dialogues"] = config.get_value("stats", "total_dialogues", 0)
	StoryManager.stats["correct_guesses"] = config.get_value("stats", "correct_guesses", 0)

	# Restore story manager state
	if story_id != "":
		StoryManager.current_story = {"id": story_id, "title": story_title}
		StoryManager.current_chapter = chapter
		StoryManager.story_progress = progress

	game_loaded.emit(current_save_path)
	print("[SaveManager] Game loaded: %s" % story_id)

	return {
		"story_id": story_id,
		"story_title": story_title,
		"chapter": chapter,
		"progress": progress
	}


# Check if save exists
func has_save() -> bool:
	return FileAccess.file_exists(current_save_path)


# Delete current save
func delete_save() -> void:
	if FileAccess.file_exists(current_save_path):
		DirAccess.remove_absolute(current_save_path)
		print("[SaveManager] Save deleted")


# Record ending in history
func record_ending(ending_data: Dictionary) -> void:
	game_history.append(ending_data)
	_save_history()


# Save history
func _save_history() -> void:
	var file = FileAccess.open(history_path, FileAccess.WRITE)
	if file:
		file.store_string(var_to_json(game_history))
		file.close()


# Load history
func load_history() -> Array:
	if FileAccess.file_exists(history_path):
		var file = FileAccess.open(history_path, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		game_history = json_to_var(content)
	return game_history


# Get history
func get_history() -> Array:
	return game_history


# Settings management
func save_setting(key: String, value: Variant) -> void:
	settings[key] = value

	var config = ConfigFile.new()
	for k in settings:
		config.set_value("settings", k, settings[k])

	var err = config.save(settings_path)
	if err == OK:
		settings_changed.emit(key, value)


func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(settings_path) == OK:
		var keys = config.get_section_keys("settings")
		if keys:
			for key in keys:
				settings[key] = config.get_value("settings", key)

	# Apply settings
	_apply_settings()


func _apply_settings() -> void:
	if AudioManager:
		AudioManager.set_bgm_volume(settings.get("bgm_volume", 0.0))
		AudioManager.set_sfx_volume(settings.get("sfx_volume", 0.0))
		AudioManager.set_ambient_volume(settings.get("ambient_volume", 0.0))


func get_setting(key: String, default: Variant = null) -> Variant:
	return settings.get(key, default)


# Utility: Var to JSON
func var_to_json(v: Variant) -> String:
	return JSON.stringify(v)


# Utility: JSON to Var
func json_to_var(s: String) -> Variant:
	if s == "" or s == "{}":
		return {}
	return JSON.parse_string(s)

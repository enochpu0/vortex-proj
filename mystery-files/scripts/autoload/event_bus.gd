extends Node
class_name EventBusClass

# ===========================================================
# Global Event Bus - Module decoupled communication
# ===========================================================

# --- Game State Events ---
signal game_state_changed(from: int, to: int)

# --- Story Events ---
signal story_started(story_id: String)
signal story_progressed(chapter: int)
signal story_ended(ending_id: String)
signal story_generated(story_data: Dictionary)

# --- Dialogue Events ---
signal dialogue_started(npc_id: String)
signal dialogue_line_shown(line_id: String)
signal player_spoke(text: String)
signal npc_response(text: String)
signal dialogue_ended()

# --- Clue Events ---
signal clue_collected(clue_id: String)
signal clue_examined(clue_id: String)

# --- Audio Events ---
signal bgm_changed(track_id: String)
signal sfx_played(sfx_id: String)
signal ambient_changed(ambient_id: String)
signal volume_changed(bus: String, volume: float)

# --- Save Events ---
signal game_saved(save_id: String)
signal game_loaded(save_id: String)
signal save_error(error: String)

# --- Voice Events ---
signal voice_input_started()
signal voice_input_finished()
signal voice_recognized(text: String)
signal voice_error(error: String)

# --- UI Events ---
signal ui_show_loading()
signal ui_hide_loading()
signal ui_show_dialog(title: String, message: String)
signal ui_show_toast(message: String)


func _ready() -> void:
	print("[EventBus] Initialized")


# Helper method to emit game state change
func emit_game_state_changed(from: int, to: int) -> void:
	game_state_changed.emit(from, to)


# Helper method to emit story events
func emit_story_started(story_id: String) -> void:
	story_started.emit(story_id)


func emit_story_progressed(chapter: int) -> void:
	story_progressed.emit(chapter)


func emit_story_ended(ending_id: String) -> void:
	story_ended.emit(ending_id)


# Helper method to emit voice events
func emit_voice_input_started() -> void:
	voice_input_started.emit()


func emit_voice_recognized(text: String) -> void:
	voice_recognized.emit(text)

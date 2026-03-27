extends Label
class_name TypewriterLabel

# ===========================================================
# Typewriter Label - Character-by-character text display
# ===========================================================

@export var char_delay: float = 0.03
@export var sfx_enabled: bool = true
@export var sfx_path: String = "res://resources/audio/sfx/dialogue_type.wav"

# Signals
signal typing_started()
signal typing_paused()
signal typing_resumed()
signal typing_finished()

# State
var full_text: String = ""
var current_index: int = 0
var is_typing: bool = false
var is_paused: bool = false

# Audio
var sfx_player: AudioStreamPlayer


func _ready() -> void:
	_setup_audio()


# Setup audio player
func _setup_audio() -> void:
	sfx_player = AudioStreamPlayer.new()
	sfx_player.bus = "SFX"
	add_child(sfx_player)


# Start typing text
func type_text(text: String) -> void:
	if is_typing:
		finish_typing()
		await get_tree().create_timer(0.1).timeout

	full_text = text
	current_index = 0
	is_typing = true
	is_paused = false
	text = ""

	typing_started.emit()

	await _type_loop()


# Typing loop
func _type_loop() -> void:
	while current_index < full_text.length() and is_typing:
		if not is_paused:
			text += full_text[current_index]
			current_index += 1

			# Play typing sound
			if sfx_enabled and sfx_path != "":
				_play_typing_sfx()

			await get_tree().create_timer(char_delay).timeout
		else:
			await get_tree().create_timer(0.1).timeout

	if is_typing:
		typing_finished.emit()


# Play typing sound effect
func _play_typing_sfx() -> void:
	if ResourceLoader.exists(sfx_path):
		if not sfx_player.playing:
			sfx_player.stream = load(sfx_path)
			sfx_player.play()


# Skip typing (show all text at once)
func finish_typing() -> void:
	if not is_typing:
		return

	text = full_text
	current_index = full_text.length()
	is_typing = false
	typing_finished.emit()


# Pause typing
func pause_typing() -> void:
	is_paused = true
	typing_paused.emit()


# Resume typing
func resume_typing() -> void:
	is_paused = false
	typing_resumed.emit()


# Skip to next line
func skip() -> void:
	finish_typing()


# Set text instantly (no typing effect)
func set_text_instant(text: String) -> void:
	is_typing = false
	full_text = text
	self.text = text


# Get current progress
func get_progress() -> float:
	if full_text.is_empty():
		return 0.0
	return float(current_index) / full_text.length()

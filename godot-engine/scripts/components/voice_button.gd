extends Button
class_name VoiceButton

# ===========================================================
# Voice Button - Hold-to-talk button for voice input
# ===========================================================

@export var voice_language: String = "zh-CN"
@export var icon_normal: Texture2D
@export var icon_recording: Texture2D

# Signals
signal voice_input_confirmed(text: String)

# State
var is_recording: bool = false

# Visual
@onready var icon_texture: TextureRect = $Icon if has_node("Icon") else null
@onready var label: Label = $Label if has_node("Label") else null


func _ready() -> void:
	_connect_signals()
	_update_visual_state()


# Connect signals
func _connect_signals() -> void:
	pressed.connect(_on_pressed)
	button_up.connect(_on_button_up)

	if VoiceService:
		VoiceService.state_changed.connect(_on_voice_state_changed)
		VoiceService.recognition_result.connect(_on_recognition_result)
		VoiceService.recognition_error.connect(_on_recognition_error)


# Button pressed - start recording
func _on_pressed() -> void:
	if VoiceService and VoiceService.current_state == VoiceService.VoiceState.IDLE:
		is_recording = true
		VoiceService.start_listening(voice_language)
		_update_visual_state()


# Handle button up - stop recording
func _on_button_up() -> void:
	if is_recording:
		is_recording = false
		if VoiceService and VoiceService.current_state == VoiceService.VoiceState.LISTENING:
			VoiceService.stop_listening()
		_update_visual_state()


# Voice service state changed
func _on_voice_state_changed(state: int) -> void:
	match state:
		VoiceService.VoiceState.IDLE:
			is_recording = false
			_update_visual_state()
		VoiceService.VoiceState.LISTENING:
			_update_visual_state()
		VoiceService.VoiceState.RECOGNIZING:
			_update_visual_state()
		VoiceService.VoiceState.ERROR:
			is_recording = false
			_update_visual_state()


# Recognition result received
func _on_recognition_result(text: String) -> void:
	if text != "":
		voice_input_confirmed.emit(text)


# Recognition error
func _on_recognition_error(error: String) -> void:
	is_recording = false
	_update_visual_state()


# Update visual state
func _update_visual_state() -> void:
	if is_recording:
		modulate = Color("#E74C3C")
		if label:
			label.text = "Recording..."
		if icon_texture and icon_recording:
			icon_texture.texture = icon_recording
	else:
		modulate = Color.WHITE
		if label:
			label.text = "Hold to Talk"
		if icon_texture and icon_normal:
			icon_texture.texture = icon_normal


# Set enabled state
func set_enabled(enabled: bool) -> void:
	disabled = not enabled
	if not enabled:
		is_recording = false
		_update_visual_state()

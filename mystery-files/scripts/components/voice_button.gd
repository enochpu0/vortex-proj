extends Button
class_name VoiceButton

# ===========================================================
# Voice Button - Hold-to-talk button for voice input
# ===========================================================

@export var language: String = "zh-CN"
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
	released.connect(_on_released)
	button_up.connect(_on_button_up)

	if VoiceService:
		VoiceService.state_changed.connect(_on_voice_state_changed)
		VoiceService.recognition_result.connect(_on_recognition_result)
		VoiceService.recognition_error.connect(_on_recognition_error)


# Button pressed - start recording
func _on_pressed() -> void:
	if VoiceService and VoiceService.current_state == VoiceService.IDLE:
		is_recording = true
		VoiceService.start_listening(language)
		_update_visual_state()


# Button released - stop recording
func _on_released() -> void:
	if is_recording:
		is_recording = false
		if VoiceService and VoiceService.current_state == VoiceService.LISTENING:
			VoiceService.stop_listening()
		_update_visual_state()


# Handle button up (also triggers on release)
func _on_button_up() -> void:
	pass


# Voice service state changed
func _on_voice_state_changed(state: int) -> void:
	match state:
		VoiceService.IDLE:
			is_recording = false
			_update_visual_state()
		VoiceService.LISTENING:
			_update_visual_state()
		VoiceService.RECOGNIZING:
			_update_visual_state()
		VoiceService.ERROR:
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

	# Show error toast
	if EventBus:
		EventBus.emit_ui_show_toast("语音识别失败：%s" % error)


# Update visual state
func _update_visual_state() -> void:
	if is_recording:
		# Recording state
		modulate = Color("#E74C3C")
		if label:
			label.text = "录音中..."
		if icon_texture and icon_recording:
			icon_texture.texture = icon_recording
	else:
		# Idle state
		modulate = Color.WHITE
		if label:
			label.text = "按住说话"
		if icon_texture and icon_normal:
			icon_texture.texture = icon_normal


# Set enabled state
func set_enabled(enabled: bool) -> void:
	disabled = not enabled
	if not enabled:
		is_recording = false
		_update_visual_state()

extends Node
class_name VoiceServiceClass

# ===========================================================
# Voice Service - Local Speech Recognition
# ===========================================================

enum VoiceState {
	IDLE,           # Not recording
	LISTENING,      # Recording audio
	RECOGNIZING,    # Processing speech
	ERROR           # Error state
}

# Signals
signal state_changed(state: VoiceState)
signal recognition_started()
signal recognition_finished()
signal recognition_result(text: String)
signal recognition_error(error: String)

# Configuration
var current_state: VoiceState = VoiceState.IDLE
var supported_languages: Array[String] = ["zh-CN", "en-US"]
var current_language: String = "zh-CN"

# Recording settings
var max_recording_duration: float = 30.0
var silence_timeout: float = 2.0

# Internal state
var recording_start_time: float = 0
var silence_timer: float = 0
var _native_plugin = null


func _ready() -> void:
	print("[VoiceService] Initialized")
	_initialize_native_plugin()
	_check_platform_support()


func _initialize_native_plugin() -> void:
	# Try to get iOS Speech plugin if on iOS platform
	if OS.get_name() == "iOS" or OS.get_name() == "macOS":
		_native_plugin = Engine.get_singleton("IOSSpeech")
		if _native_plugin:
			print("[VoiceService] iOS Speech plugin found, connecting signals...")
			_native_plugin.connect("transcription_completed", _on_native_transcription_completed)
			_native_plugin.connect("recording_started", _on_native_recording_started)
			_native_plugin.connect("recording_stopped", _on_native_recording_stopped)
			_native_plugin.connect("error_occurred", _on_native_plugin_error)
			print("[VoiceService] iOS Speech plugin connected successfully")
		else:
			print("[VoiceService] iOS Speech plugin not found, using simulation mode")


# Check platform support
func _check_platform_support() -> void:
	# iOS Speech Framework support check
	if OS.get_name() == "iOS":
		print("[VoiceService] iOS detected - Speech Framework available")
	elif OS.get_name() == "macOS":
		print("[VoiceService] macOS detected - Speech Framework available")
	else:
		print("[VoiceService] Platform may not support speech recognition")


# ===========================================================
# Public API
# ===========================================================

# Start listening
func start_listening(language: String = "zh-CN") -> void:
	if current_state != VoiceState.IDLE:
		print("[VoiceService] Already in state: %d" % current_state)
		return

	if language in supported_languages:
		current_language = language

	current_state = VoiceState.LISTENING
	recording_start_time = Time.get_unix_time_from_system()
	silence_timer = 0

	state_changed.emit(current_state)
	recognition_started.emit()
	EventBus.emit_voice_input_started()

	print("[VoiceService] Started listening (language: %s)" % current_language)

	# Start native recording
	_start_native_recording()


# Stop listening
func stop_listening() -> void:
	if current_state != VoiceState.LISTENING:
		return

	current_state = VoiceState.RECOGNIZING
	state_changed.emit(current_state)

	print("[VoiceService] Stopped listening, processing...")

	# Stop native recording
	_stop_native_recording()


# Cancel recognition
func cancel() -> void:
	if current_state == VoiceState.IDLE:
		return

	current_state = VoiceState.IDLE
	state_changed.emit(current_state)

	_cancel_native_recording()
	print("[VoiceService] Cancelled")


# ===========================================================
# Native Recording Methods (Platform Specific)
# ===========================================================

func _start_native_recording() -> void:
	if _native_plugin:
		print("[VoiceService] Starting native recording via iOS Speech plugin")
		_native_plugin.start_recording()
	else:
		# Simulation mode for non-iOS platforms
		print("[VoiceService] Starting native recording (simulated)")
		await get_tree().create_timer(3.0).timeout
		_on_native_recognition_result("这是一个测试识别结果")


func _stop_native_recording() -> void:
	if _native_plugin:
		_native_plugin.stop_recording()
	else:
		print("[VoiceService] Stopping native recording")


func _cancel_native_recording() -> void:
	if _native_plugin:
		_native_plugin.cancel_recording()
	else:
		print("[VoiceService] Cancelling native recording")


# ===========================================================
# Native Callbacks
# ===========================================================

func _on_native_recognition_started() -> void:
	print("[VoiceService] Native recognition started")


func _on_native_transcription_completed(text: String) -> void:
	_on_native_recognition_result(text)


func _on_native_recording_started() -> void:
	print("[VoiceService] Native recording started signal received")


func _on_native_recording_stopped() -> void:
	print("[VoiceService] Native recording stopped signal received")


func _on_native_plugin_error(error: String) -> void:
	_on_native_recognition_error(error)


func _on_native_recognition_result(text: String) -> void:
	current_state = VoiceState.IDLE
	state_changed.emit(current_state)
	recognition_finished.emit()
	recognition_result.emit(text)
	EventBus.emit_voice_recognized(text)

	print("[VoiceService] Recognition result: %s" % text)


func _on_native_recognition_error(error: String) -> void:
	current_state = VoiceState.ERROR
	state_changed.emit(current_state)
	recognition_error.emit(error)
	EventBus.voice_error.emit(error)

	print("[VoiceService] Recognition error: %s" % error)


# ===========================================================
# Process - Handle silence timeout
# ===========================================================

func _process(delta: float) -> void:
	if current_state == VoiceState.LISTENING:
		silence_timer += delta

		# Check max duration
		var elapsed = Time.get_unix_time_from_system() - recording_start_time
		if elapsed > max_recording_duration:
			print("[VoiceService] Max recording duration reached")
			stop_listening()

		# Silence timeout detection would go here
		# In production, analyze audio stream for silence

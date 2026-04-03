extends Control
class_name SoundWave

# ===========================================================
# Sound Wave - Pixel-style audio waveform visualization
# ===========================================================

@export var bar_count: int = 5
@export var bar_width: int = 8
@export var bar_spacing: int = 4
@export var max_height: float = 50.0
@export var bar_color: Color = Color("#2EC4B6")

# Internal
var bars: Array = []
var amplitudes: Array = []


func _ready() -> void:
	_create_bars()
	_connect_voice_service()


# Create bar controls
func _create_bars() -> void:
	# Clear existing
	for bar in bars:
		if is_instance_valid(bar):
			bar.queue_free()
	bars.clear()

	# Create new bars
	for i in bar_count:
		var bar = ColorRect.new()
		bar.name = "bar_%d" % i
		bar.color = bar_color
		bar.custom_minimum_size = Vector2(bar_width, 10)

		# Position
		bar.position.x = i * (bar_width + bar_spacing)
		bar.anchor_left = 0.5
		bar.anchor_right = 0.5
		bar.offset_left = -bar_width / 2
		bar.offset_right = bar_width / 2

		add_child(bar)
		bars.append(bar)

	# Initialize amplitudes
	amplitudes.clear()
	for i in bar_count:
		amplitudes.append([0.2, 0.4, 0.6, 0.4, 0.2][i])


# Connect to voice service
func _connect_voice_service() -> void:
	if VoiceService:
		VoiceService.recognition_started.connect(_on_recognition_started)
		VoiceService.recognition_finished.connect(_on_recognition_finished)
		VoiceService.recognition_result.connect(_on_recognition_finished)


# Update bar heights based on amplitudes
func update_amplitudes(new_amplitudes: Array) -> void:
	for i in min(bar_count, new_amplitudes.size()):
		if is_instance_valid(bars[i]):
			var height = new_amplitudes[i] * max_height
			bars[i].custom_minimum_size.y = max(10, height)
			bars[i].position.y = (max_height - height) / 2


# Animate bars (simulation mode)
func animate_simulated() -> void:
	while VoiceService and VoiceService.current_state == VoiceService.LISTENING:
		var new_amplitudes = []
		for i in bar_count:
			# Generate random amplitude with smooth transitions
			var target = randf_range(0.3, 1.0)
			amplitudes[i] = lerp(amplitudes[i], target, 0.3)
			new_amplitudes.append(amplitudes[i])

		update_amplitudes(new_amplitudes)
		await get_tree().create_timer(0.1).timeout


# Start animation
func _on_recognition_started() -> void:
	visible = true
	for bar in bars:
		if is_instance_valid(bar):
			bar.color = bar_color

	# Start simulated animation
	await animate_simulated()


# Stop animation
func _on_recognition_finished() -> void:
	# Set all bars to full height briefly
	update_amplitudes([1.0, 1.0, 1.0, 1.0, 1.0])

	await get_tree().create_timer(0.3).timeout
	visible = false


# Set idle state
func set_idle() -> void:
	update_amplitudes([0.2, 0.2, 0.2, 0.2, 0.2])


# Set error state
func set_error() -> void:
	for bar in bars:
		if is_instance_valid(bar):
			bar.color = Color("#E74C3C")

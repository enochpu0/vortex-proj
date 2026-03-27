extends Control

# ===========================================================
# Dialogue Scene Script
# ===========================================================

@onready var npc_portrait: TextureRect = $NPCPortrait
@onready var npc_name: Label = $NPCName
@onready var dialogue_text: TypewriterLabel = $DialogueBox/DialogueText
@onready var voice_button: VoiceButton = $VoiceButton
@onready var sound_wave: SoundWave = $SoundWave

# Current dialogue state
var current_npc_id: String = ""
var current_dialogue: String = ""
var is_npc_speaking: bool = false


func _ready() -> void:
	_connect_signals()
	_initialize_dialogue()

	# Pause BGM during dialogue
	if AudioManager:
		AudioManager.duck_bgm_for_dialogue()

	print("[Dialogue] Ready")


# Connect signals
func _connect_signals() -> void:
	if voice_button:
		voice_button.voice_input_confirmed.connect(_on_voice_confirmed)

	if VoiceService:
		VoiceService.recognition_result.connect(_on_voice_result)

	if dialogue_text:
		dialogue_text.typing_finished.connect(_on_typing_finished)


# Initialize dialogue
func _initialize_dialogue() -> void:
	# Get current NPC from story
	var npcs = StoryManager.current_story.get("npcs", [])
	if npcs.size() > 0:
		var npc = npcs[0]
		current_npc_id = npc.get("id", "npc_doctor")
		_load_npc(current_npc_id)

		# Start dialogue
		await get_tree().create_timer(0.5).timeout
		_start_dialogue()


# Load NPC data
func _load_npc(npc_id: String) -> void:
	var npc_data = NPCManager.load_npc(npc_id)
	npc_name.text = npc_data.get("name", "Unknown")

	# Load portrait
	var sprite_path = npc_data.get("sprite_path", "")
	if sprite_path != "" and ResourceLoader.exists(sprite_path):
		npc_portrait.texture = load(sprite_path)


# Start dialogue
func _start_dialogue() -> void:
	# NPC greeting
	var greetings = [
		"你终于来了。我等你很久了。",
		"有什么想了解的吗？",
		"这个房子里有很多秘密...",
		"你想问什么？"
	]
	var greeting = greetings[randi() % greetings.size()]

	_show_npc_dialogue(greeting)


# Show NPC dialogue
func _show_npc_dialogue(text: String) -> void:
	is_npc_speaking = true
	dialogue_text.type_text(text)
	EventBus.emit_dialogue_started(current_npc_id)


# Voice input confirmed
func _on_voice_confirmed(text: String) -> void:
	_on_voice_result(text)


# Voice recognition result
func _on_voice_result(text: String) -> void:
	if text == "":
		return

	print("[Dialogue] Player said: %s" % text)

	# Show player input (optional)
	# Then get NPC response
	_get_npc_response(text)


# Get NPC response
func _get_npc_response(player_input: String) -> void:
	is_npc_speaking = true

	# Disable voice button during response
	if voice_button:
		voice_button.disabled = true

	var response = await NPCManager.get_npc_response(current_npc_id, player_input)

	# Record dialogue
	StoryManager.record_dialogue(current_npc_id, player_input, response)

	# Show response
	dialogue_text.type_text(response)

	# Re-enable voice button
	if voice_button:
		voice_button.disabled = false


# Typing finished
func _on_typing_finished() -> void:
	is_npc_speaking = false


# Exit dialogue
func _exit_dialogue() -> void:
	if AudioManager:
		AudioManager.restore_bgm_volume()

	GameState.go_to_explore()


# Handle scene exit
func _on_exit_pressed() -> void:
	_exit_dialogue()

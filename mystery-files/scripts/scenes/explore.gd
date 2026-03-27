extends Control

# ===========================================================
# Explore Scene Script
# ===========================================================

@onready var chapter_title: Label = $ChapterTitle
@onready var scene_image: TextureRect = $SceneImage
@onready var scene_name: Label = $SceneName
@onready var clue_button: Button = $BottomButtons/ClueButton
@onready var dialogue_button: Button = $BottomButtons/DialogueButton
@onready var menu_button: Button = $BottomButtons/MenuButton

# Current scene data
var current_scene_id: String = ""
var current_chapter: int = 1


func _ready() -> void:
	_connect_buttons()
	_load_current_scene()

	# Play explore BGM
	if AudioManager:
		AudioManager.play_bgm("mystery_1", 1.0)

	print("[Explore] Ready")


# Connect button signals
func _connect_buttons() -> void:
	clue_button.pressed.connect(_on_clue_pressed)
	dialogue_button.pressed.connect(_on_dialogue_pressed)
	menu_button.pressed.connect(_on_menu_pressed)


# Load current scene from story
func _load_current_scene() -> void:
	var story = StoryManager.get_current_story()
	if story.is_empty():
		return

	current_chapter = StoryManager.current_chapter
	var chapters = story.get("chapters", [])

	if current_chapter <= chapters.size():
		var chapter = chapters[current_chapter - 1]
		chapter_title.text = "Chapter %d: %s" % [current_chapter, chapter.get("title", "")]

		# Load first scene of chapter
		var scenes = chapter.get("scenes", [])
		if scenes.size() > 0:
			_load_scene(scenes[0])


# Load specific scene
func _load_scene(scene_id: String) -> void:
	current_scene_id = scene_id

	# Update scene name
	var scene_names = {
		"study": "🔍 书房",
		"living_room": "🛋️ 客厅",
		"hallway": "🚪 走廊",
		"office": "📁 办公室",
		"garden": "🌳 花园",
		"kitchen": "🍳 厨房"
	}
	scene_name.text = scene_names.get(scene_id, scene_id)

	# Load scene image (placeholder)
	# scene_image.texture = load("res://resources/sprites/scenes/%s.png" % scene_id)


# Button callbacks
func _on_clue_pressed() -> void:
	print("[Explore] Clue button pressed")
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Show collected clues for current scene
	var clues = ClueManager.get_collected_clues()
	var message = "已收集线索：%d" % clues.size()
	EventBus.emit_ui_show_toast(message)


func _on_dialogue_pressed() -> void:
	print("[Explore] Dialogue button pressed")
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Check if any NPCs available
	GameState.go_to_dialogue()


func _on_menu_pressed() -> void:
	print("[Explore] Menu button pressed")
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Show pause menu
	GameState.go_to_menu()


# Auto-save on enter
func _on_enter() -> void:
	if SaveManager:
		SaveManager.save_game()

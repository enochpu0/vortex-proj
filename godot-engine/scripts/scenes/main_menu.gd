extends Control

# ===========================================================
# Main Menu Scene
# ===========================================================

@onready var continue_button: Button = $VBoxContainer/ContinueButton
@onready var new_game_button: Button = $VBoxContainer/NewGameButton
@onready var archive_button: Button = $VBoxContainer/ArchiveButton
@onready var settings_button: Button = $VBoxContainer/SettingsButton
@onready var title_label: Label = $VBoxContainer/TitleLabel

# Button styles
var normal_style: StyleBoxFlat
var hover_style: StyleBoxFlat
var pressed_style: StyleBoxFlat


func _ready() -> void:
	_setup_styles()
	_connect_buttons()
	_check_save_file()

	# Play menu BGM
	if AudioManager:
		AudioManager.play_bgm("main_theme", 1.0)

	print("[MainMenu] Ready")


# Setup button styles
func _setup_styles() -> void:
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color.TRANSPARENT
	normal_style.border_color = Color("#2EC4B6")
	normal_style.border_width_left = 2
	normal_style.border_width_right = 2
	normal_style.border_width_top = 2
	normal_style.border_width_bottom = 2

	hover_style = normal_style.duplicate()
	hover_style.border_color = Color("#3EDDD0")

	pressed_style = normal_style.duplicate()
	pressed_style.bg_color = Color("#2EC4B6")


# Connect button signals
func _connect_buttons() -> void:
	continue_button.pressed.connect(_on_continue_pressed)
	new_game_button.pressed.connect(_on_new_game_pressed)
	archive_button.pressed.connect(_on_archive_pressed)
	settings_button.pressed.connect(_on_settings_pressed)

	# Hover effects
	for btn in [continue_button, new_game_button, archive_button, settings_button]:
		btn.mouse_entered.connect(_on_button_hover.bind(btn))
		btn.mouse_exited.connect(_on_button_unhover.bind(btn))


# Check if save file exists
func _check_save_file() -> void:
	var has_save = SaveManager.has_save() if SaveManager else false
	continue_button.visible = has_save
	continue_button.disabled = not has_save


# Button callbacks
func _on_new_game_pressed() -> void:
	print("[MainMenu] Starting new game")
	AudioManager.play_sfx("button_click")

	# Start new story
	await StoryManager.generate_new_story()

	# Change state and load scene
	GameState.go_to_explore()


func _on_continue_pressed() -> void:
	print("[MainMenu] Continuing game")
	AudioManager.play_sfx("button_click")

	var save_data = SaveManager.load_game()
	if save_data:
		GameState.go_to_explore()


func _on_archive_pressed() -> void:
	print("[MainMenu] Opening archive")
	AudioManager.play_sfx("button_click")
	GameState.go_to_archive()


func _on_settings_pressed() -> void:
	print("[MainMenu] Opening settings")
	AudioManager.play_sfx("button_click")
	GameState.go_to_settings()


# Hover effects
func _on_button_hover(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "position:x", btn.position.x + 4, 0.15)


func _on_button_unhover(btn: Button) -> void:
	var tween = create_tween()
	tween.tween_property(btn, "position:x", btn.position.x - 4, 0.15)


# Handle scene transition
func _on_scene_transition_finished() -> void:
	queue_free()

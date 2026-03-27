extends Control

# ===========================================================
# Archive Scene Script
# ===========================================================

@onready var stats_label: Label = $StatsContainer/StatsGrid
@onready var history_list: VBoxContainer = $HistoryContainer/HistoryList

# History data
var history: Array = []


func _ready() -> void:
	_connect_buttons()
	_load_history()

	print("[Archive] Ready")


# Connect buttons
func _connect_buttons() -> void:
	var back_button = $Header/BackButton
	if back_button:
		back_button.pressed.connect(_on_back_pressed)


# Load history from save manager
func _load_history() -> void:
	if SaveManager:
		history = SaveManager.get_history()
	else:
		history = []

	_update_stats()
	_update_history_list()


# Update statistics
func _update_stats() -> void:
	var total = history.size()
	var completed = 0
	var mystery = 0

	for entry in history:
		if entry.get("ending_id") == "mystery_ending":
			mystery += 1
		else:
			completed += 1

	if stats_label:
		stats_label.text = "%d 案件    %d 通关    %d 悬案" % [total, completed, mystery]


# Update history list
func _update_history_list() -> void:
	# Clear existing
	for child in history_list.get_children():
		child.queue_free()

	# Add history entries
	for entry in history:
		var item = _create_history_item(entry)
		history_list.add_child(item)


# Create history item
func _create_history_item(entry: Dictionary) -> HBoxContainer:
	var item = HBoxContainer.new()
	item.add_theme_constant_override("separation", 20)

	# Title
	var title = Label.new()
	title.text = entry.get("story_title", "Unknown Story")
	title.custom_minimum_size = Vector2(200, 40)
	item.add_child(title)

	# Ending
	var ending = Label.new()
	ending.text = entry.get("ending_name", "Unknown")
	ending.custom_minimum_size = Vector2(150, 40)
	item.add_child(ending)

	# Score
	var score = Label.new()
	var stars = _score_to_stars(entry.get("score", 0))
	score.text = stars
	score.custom_minimum_size = Vector2(100, 40)
	item.add_child(score)

	# Time
	var time = Label.new()
	var play_time = entry.get("play_time", 0)
	var minutes = int(play_time / 60)
	time.text = "%d 分" % minutes
	time.custom_minimum_size = Vector2(80, 40)
	item.add_child(time)

	return item


# Convert score to stars
func _score_to_stars(score: int) -> String:
	if score >= 80:
		return "★★★★★"
	elif score >= 60:
		return "★★★★☆"
	elif score >= 40:
		return "★★★☆☆"
	elif score >= 20:
		return "★★☆☆☆"
	else:
		return "★☆☆☆☆"


# Back button pressed
func _on_back_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")

	GameState.go_to_menu()

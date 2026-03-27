extends Control

# ===========================================================
# Ending Scene Script
# ===========================================================

@onready var ending_title: Label = $EndingTitle
@onready var star_rating: Label = $StarRating
@onready var stats_label: Label = $StatsPanel/StatsLabel
@onready var next_button: Button = $NextButton

# Ending data
var ending_id: String = ""
var ending_data: Dictionary = {}


func _ready() -> void:
	_connect_buttons()
	_load_ending()

	# Play ending BGM
	if AudioManager:
		AudioManager.play_bgm("ending", 1.0)

	print("[Ending] Ready")


# Connect buttons
func _connect_buttons() -> void:
	next_button.pressed.connect(_on_next_pressed)


# Load ending data
func _load_ending() -> void:
	# Get ending from story manager
	ending_id = StoryManager.calculate_ending()
	var score = StoryManager.calculate_score()
	var progress = StoryManager.get_progress_summary()

	# Update UI
	_update_ending_title(ending_id)
	_update_stars(score)
	_update_stats(progress)

	# Record ending
	ending_data = {
		"story_id": StoryManager.current_story.get("id"),
		"story_title": StoryManager.current_story.get("title"),
		"ending_id": ending_id,
		"score": score,
		"play_time": progress.play_time,
		"collected_clues": progress.collected_clues.size(),
		"timestamp": Time.get_unix_time_from_system()
	}

	# Save to history
	if SaveManager:
		SaveManager.record_ending(ending_data)
		SaveManager.delete_save()  # Clear current save after completion


# Update ending title
func _update_ending_title(ending_id: String) -> void:
	var titles = {
		"truth_ending": "结局：真相的碎片",
		"partial_ending": "结局：未解之谜",
		"mystery_ending": "结局：悬案"
	}
	ending_title.text = titles.get(ending_id, "结局：未知")


# Update star rating
func _update_stars(score: int) -> void:
	var stars = ""
	if score >= 80:
		stars = "★★★★★"
	elif score >= 60:
		stars = "★★★★☆"
	elif score >= 40:
		stars = "★★★☆☆"
	elif score >= 20:
		stars = "★★☆☆☆"
	else:
		stars = "★☆☆☆☆"

	star_rating.text = stars


# Update statistics
func _update_stats(progress: Dictionary) -> void:
	var play_time_min = int(progress.play_time / 60)
	var play_time_sec = int(progress.play_time) % 60

	var stats_text = """对话次数：%d
关键线索：%d/%d
用时：%02d 分 %02d 秒""" % [
		StoryManager.stats.total_dialogues,
		progress.collected_clues.size(),
		StoryManager.current_story.get("clues", []).size(),
		play_time_min,
		play_time_sec
	]

	stats_label.text = stats_text


# Next button pressed
func _on_next_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Start new game
	GameState.go_to_menu()


# Handle scene transition
func _on_transition_in() -> void:
	modulate.a = 0
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)

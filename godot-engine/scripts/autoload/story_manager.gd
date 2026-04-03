extends Node
class_name StoryManagerClass

# ===========================================================
# Story Manager - Manages story data and progress
# ===========================================================

# Signals
signal story_generated(story_data: Dictionary)
signal story_loaded(story_data: Dictionary)
signal chapter_completed(chapter: int)
signal all_chapters_completed()

# Current story data
var current_story: Dictionary = {}
var current_chapter: int = 1
var story_progress: Dictionary = {
	"collected_clues": [],
	"talked_npcs": [],
	"visited_scenes": [],
	"dialogue_history": [],
	"start_time": 0,
	"play_time": 0
}

# Story statistics
var stats: Dictionary = {
	"total_dialogues": 0,
	"correct_guesses": 0,
	"total_guesses": 0
}


func _ready() -> void:
	print("[StoryManager] Initialized")


# Generate a new story using AI
func generate_new_story() -> void:
	var prompt = {
		"type": "mystery",
		"length": "medium",
		"chapters": 3,
		"endings": 3,
		"npcs": 4,
		"clues": 6
	}

	if AIService:
		var story_data = await AIService.generate_story(prompt)
		set_story(story_data)
	else:
		# Fallback to template
		load_story_from_template()


# Load story from template (fallback)
func load_story_from_template() -> void:
	var template_path = "res://data/story_templates/sample_story.json"
	if ResourceLoader.exists(template_path):
		var story_data = _load_json(template_path)
		if not story_data.is_empty():
			set_story(story_data)
			print("[StoryManager] Loaded story template: %s" % template_path)
			return
	print("[StoryManager] Template not found, using sample story")
	var story_data = _create_sample_story()
	set_story(story_data)


func _load_json(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		return {}
	var content = file.get_as_text()
	file.close()
	var json = JSON.new()
	if json.parse(content) == OK:
		return json.get_data()
	return {}


# Set the current story
func set_story(story_data: Dictionary) -> void:
	current_story = story_data
	current_chapter = 1
	story_progress = {
		"collected_clues": [],
		"talked_npcs": [],
		"visited_scenes": [],
		"dialogue_history": [],
		"start_time": Time.get_unix_time_from_system(),
		"play_time": 0.0
	}
	stats = {
		"total_dialogues": 0,
		"correct_guesses": 0,
		"total_guesses": 0
	}

	print("[StoryManager] Story set: %s" % story_data.get("title", "Unknown"))
	EventBus.emit_story_started(story_data.get("id", "unknown"))


# Get current story
func get_current_story() -> Dictionary:
	return current_story


# Get current chapter
func get_current_chapter() -> int:
	return current_chapter


# Progress management
func advance_chapter() -> void:
	current_chapter += 1

	if current_chapter > current_story.get("chapters", []).size():
		trigger_ending()
	else:
		chapter_completed.emit(current_chapter)
		EventBus.emit_story_progressed(current_chapter)


# Clue collection
func collect_clue(clue_id: String) -> void:
	if clue_id not in story_progress["collected_clues"]:
		story_progress["collected_clues"].append(clue_id)
		EventBus.emit_clue_collected(clue_id)
		print("[StoryManager] Clue collected: %s" % clue_id)


# NPC interaction
func talk_to_npc(npc_id: String) -> void:
	if npc_id not in story_progress["talked_npcs"]:
		story_progress["talked_npcs"].append(npc_id)


# Scene visit
func visit_scene(scene_id: String) -> void:
	if scene_id not in story_progress["visited_scenes"]:
		story_progress["visited_scenes"].append(scene_id)


# Record dialogue
func record_dialogue(npc_id: String, player_text: String, npc_text: String) -> void:
	story_progress["dialogue_history"].append({
		"npc_id": npc_id,
		"player": player_text,
		"npc": npc_text,
		"timestamp": Time.get_unix_time_from_system()
	})
	stats["total_dialogues"] = stats.get("total_dialogues", 0) + 1


# Trigger ending
func trigger_ending() -> void:
	var ending_id = calculate_ending()
	EventBus.emit_story_ended(ending_id)
	all_chapters_completed.emit()


# Calculate ending based on progress
func calculate_ending() -> String:
	var score = calculate_score()

	var endings = current_story.get("endings", [])
	if endings.is_empty():
		return "default_ending"

	if score >= 80:
		return endings[0] if endings.size() > 0 else "truth_ending"
	elif score >= 50:
		return endings[1] if endings.size() > 1 else "partial_ending"
	else:
		return endings[-1] if endings.size() > 0 else "mystery_ending"


# Calculate score (0-100)
func calculate_score() -> int:
	if current_story.is_empty():
		return 0

	var clues = current_story.get("clues", [])
	if clues.is_empty():
		return 0

	var collected = story_progress["collected_clues"].size()
	return int((float(collected) / clues.size()) * 100)


# Get progress summary
func get_progress_summary() -> Dictionary:
	return {
		"story_id": current_story.get("id"),
		"chapter": current_chapter,
		"collected_clues": story_progress["collected_clues"],
		"talked_npcs": story_progress["talked_npcs"],
		"visited_scenes": story_progress["visited_scenes"],
		"score": calculate_score(),
		"play_time": Time.get_unix_time_from_system() - story_progress["start_time"]
	}


# Create sample story for testing
func _create_sample_story() -> Dictionary:
	return {
		"id": "story_sample",
		"title": "午夜的访客",
		"chapters": [
			{"id": "ch1", "title": "第一夜", "scenes": ["study", "living_room"]},
			{"id": "ch2", "title": "线索", "scenes": ["office", "street"]},
			{"id": "ch3", "title": "真相", "scenes": ["mansion"]}
		],
		"npcs": [
			{"id": "npc_doctor", "name": "史密斯医生", "role": "家庭医生"},
			{"id": "npc_butler", "name": "管家威尔逊", "role": "管家"},
			{"id": "npc_nephew", "name": "侄子杰克", "role": "继承人"}
		],
		"clues": [
			{"id": "clue_letter", "name": "带血的信纸", "location": "study"},
			{"id": "clue_watch", "name": "破碎的怀表", "location": "living_room"},
			{"id": "clue_photo", "name": "旧照片", "location": "office"}
		],
		"endings": ["truth_ending", "partial_ending", "mystery_ending"]
	}

extends Node
class_name NPCManagerClass

# ===========================================================
# NPC Manager - Manages NPC data and dialogue
# ===========================================================

enum NPCState {
	IDLE,       # Not interacting
	TALKING,    # Currently in dialogue
	REACTING    # Reacting to player input
}

# Signals
signal npc_loaded(npc_id: String)
signal npc_response_ready(npc_id: String, response: String)
signal npc_expression_changed(npc_id: String, expression: String)

# NPC database (cached)
var npc_database: Dictionary = {}

# Current interacting NPC
var current_npc: String = ""
var npc_states: Dictionary = {}


func _ready() -> void:
	print("[NPCManager] Initialized")


# Load NPC data
func load_npc(npc_id: String) -> Dictionary:
	if npc_id in npc_database:
		return npc_database[npc_id]

	var npc_data: Dictionary

	# Try to load from data file
	var path = "res://data/npcs/%s.json" % npc_id
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var content = file.get_as_text()
		npc_data = JSON.parse_string(content)
	else:
		# Generate via AI or use default
		npc_data = await _generate_npc(npc_id)

	npc_database[npc_id] = npc_data
	npc_states[npc_id] = NPCState.IDLE
	npc_loaded.emit(npc_id)

	return npc_data


# Generate NPC via AI (fallback to default)
func _generate_npc(npc_id: String) -> Dictionary:
	# In production, this would call AIService
	# For now, return default NPC data
	return _create_default_npc(npc_id)


# Create default NPC data
func _create_default_npc(npc_id: String) -> Dictionary:
	var npcs = {
		"npc_doctor": {
			"id": "npc_doctor",
			"name": "史密斯医生",
			"role": "家庭医生",
			"background": "在这所房子里工作了 20 年的家庭医生，知道所有秘密。",
			"personality": "冷静、专业、话少",
			"sprite_path": "res://resources/sprites/characters/doctor.png",
			"expressions": {
				"neutral": "normal",
				"happy": "smile",
				"angry": "mad",
				"surprised": "shock",
				"confused": "puzzle",
				"sad": "concerned"
			}
		},
		"npc_butler": {
			"id": "npc_butler",
			"name": "管家威尔逊",
			"role": "管家",
			"background": "忠诚的管家，伺候这个家族已经三代了。",
			"personality": "恭敬、谨慎、有所保留",
			"sprite_path": "res://resources/sprites/characters/butler.png",
			"expressions": {
				"neutral": "normal",
				"happy": "polite_smile",
				"angry": "stern",
				"surprised": "startled",
				"confused": "uncertain",
				"sad": "somber"
			}
		},
		"npc_nephew": {
			"id": "npc_nephew",
			"name": "侄子杰克",
			"role": "继承人",
			"background": "去世者的侄子，是第一继承人，但最近和死者有争执。",
			"personality": "急躁、防御性强、焦虑",
			"sprite_path": "res://resources/sprites/characters/nephew.png",
			"expressions": {
				"neutral": "normal",
				"happy": "relieved",
				"angry": "angry",
				"surprised": "shocked",
				"confused": "confused",
				"sad": "worried"
			}
		}
	}

	return npcs.get(npc_id, {
		"id": npc_id,
		"name": "未知角色",
		"role": "路人",
		"background": "一个神秘的人物。",
		"personality": "中性",
		"sprite_path": "",
		"expressions": {"neutral": "normal"}
	})


# Get NPC response to player input
func get_npc_response(npc_id: String, player_input: String) -> String:
	current_npc = npc_id
	npc_states[npc_id] = NPCState.TALKING

	var npc_data = load_npc(npc_id)

	# In production, this would call AI service for local model inference
	var response = await _generate_dialogue_response(npc_data, player_input)

	npc_states[npc_id] = NPCState.IDLE
	npc_response_ready.emit(npc_id, response)

	return response


# Generate dialogue response (placeholder)
func _generate_dialogue_response(npc_data: Dictionary, player_input: String) -> String:
	await get_tree().create_timer(0.5).timeout

	var name = npc_data.get("name", "NPC")
	var personality = npc_data.get("personality", "neutral")

	# Simple response based on keywords (placeholder for AI)
	player_input = player_input.to_lower()

	if "谁" in player_input or "who" in player_input:
		return "我是%s。这很重要吗？" % name
	elif "发生什么" in player_input or "what" in player_input:
		return "发生了很多事...我不想回忆那些。"
	elif "为什么" in player_input or "why" in player_input:
		return "有些事情最好不知道原因。"
	elif "在哪里" in player_input or "where" in player_input:
		return "这房子里有很多秘密...有些地方你不该去。"
	else:
		var responses = [
			"嗯...有趣的说法。",
			"我明白了。",
			"这能说明什么呢？",
			"也许你是对的，也许不是。",
			"我不能说太多，但..."
		]
		return responses[randi() % responses.size()]


# Get NPC expression for emotion
func get_npc_expression(npc_id: String, emotion: String) -> String:
	var npc_data = load_npc(npc_id)
	var expressions = npc_data.get("expressions", {})
	return expressions.get(emotion, expressions.get("neutral", "normal"))


# Set NPC state
func set_npc_state(npc_id: String, state: NPCState) -> void:
	npc_states[npc_id] = state


# Get NPC state
func get_npc_state(npc_id: String) -> NPCState:
	return npc_states.get(npc_id, NPCState.IDLE)


# Get all NPCs
func get_all_npcs() -> Array:
	var result = []
	for npc_id in npc_database:
		result.append(npc_database[npc_id])
	return result

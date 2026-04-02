extends Node
class_name AIServiceClass

var cloud_api_key: String = ""
var cloud_endpoint: String = "https://api.openai.com/v1/chat/completions"
var cloud_model: String = "gpt-4"
var story_cache: Dictionary = {}
var npc_cache: Dictionary = {}


func _ready() -> void:
	print("[AIService] Initialized")


func generate_story(prompt: Dictionary) -> Dictionary:
	return {
		"id": "sample",
		"title": "Sample Story",
		"chapters": [],
		"npcs": [],
		"clues": [],
		"endings": []
	}


func generate_npc(npc_id: String) -> Dictionary:
	return {
		"id": npc_id,
		"name": "Unknown",
		"role": "NPC"
	}


func get_dialogue_response(npc_id: String, player_input: String) -> String:
	return "Hello."

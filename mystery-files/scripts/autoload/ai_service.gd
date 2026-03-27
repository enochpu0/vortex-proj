extends Node
class_name AIServiceClass

# ===========================================================
# AI Service - Cloud LLM and Local Model Integration
# ===========================================================

# Configuration
var cloud_api_key: String = ""
var cloud_endpoint: String = "https://api.openai.com/v1/chat/completions"
var cloud_model: String = "gpt-4"
var local_model_path: String = "res://assets/models/dialogue_model.onnx"

# Local model (placeholder for ONNX integration)
var local_model: Variant = null
var local_model_loaded: bool = false

# Cache for generated content
var story_cache: Dictionary = {}
var npc_cache: Dictionary = {}


func _ready() -> void:
	_load_config()
	# _load_local_model()
	print("[AIService] Initialized")


# Load configuration from file
func _load_config() -> void:
	var config_path = "res://data/config/ai_config.json"
	if FileAccess.file_exists(config_path):
		var file = FileAccess.open(config_path, FileAccess.READ)
		var content = file.get_as_text()
		var config = JSON.parse_string(content)

		if config:
			cloud_api_key = config.get("cloud", {}).get("api_key", "")
			cloud_endpoint = config.get("cloud", {}).get("endpoint", cloud_endpoint)
			cloud_model = config.get("cloud", {}).get("model", cloud_model)


# Load local ONNX model (placeholder)
func _load_local_model() -> void:
	# In production, integrate ONNX Runtime GDNative
	# Example: var model = ONNXModel.load(local_model_path)
	print("[AIService] Loading local model from: %s" % local_model_path)
	await get_tree().create_timer(1.0).timeout
	local_model_loaded = true


# ===========================================================
# Cloud LLM - Story Generation
# ===========================================================

# Generate a new story
func generate_story(prompt: Dictionary) -> Dictionary:
	# Check cache first
	var cache_key = _generate_cache_key(prompt)
	if cache_key in story_cache:
		print("[AIService] Returning cached story")
		return story_cache[cache_key]

	# Build request
	var system_prompt = "你是一位悬疑故事作家，擅长创作短篇互动悬疑故事。请生成一个完整的故事框架。"

	var request = {
		"model": cloud_model,
		"messages": [
			{"role": "system", "content": system_prompt},
			{"role": "user", "content": JSON.stringify(prompt)}
		],
		"temperature": 0.8,
		"max_tokens": 2000,
		"response_format": {"type": "json_object"}
	}

	# Send request
	var response = await _send_cloud_request(request)

	if response:
		var story = _parse_story_response(response)
		story_cache[cache_key] = story
		EventBus.emit_story_generated(story)
		return story
	else:
		# Fallback to sample story
		print("[AIService] Cloud request failed, using fallback")
		return StoryManager._create_sample_story()


# Generate NPC data
func generate_npc(npc_id: String) -> Dictionary:
	if npc_id in npc_cache:
		return npc_cache[npc_id]

	var prompt = {
		"type": "npc",
		"id": npc_id,
		"game": "mystery_narrative"
	}

	var request = {
		"model": cloud_model,
		"messages": [
			{"role": "system", "content": "创建一个悬疑游戏中的 NPC 角色。"},
			{"role": "user", "content": JSON.stringify(prompt)}
		],
		"temperature": 0.7,
		"max_tokens": 500,
		"response_format": {"type": "json_object"}
	}

	var response = await _send_cloud_request(request)

	if response:
		var npc_data = _parse_npc_response(response)
		npc_cache[npc_id] = npc_data
		return npc_data
	else:
		return _create_default_npc(npc_id)


# ===========================================================
# Local Model - Dialogue Generation
# ===========================================================

# Get dialogue response from local model
func get_dialogue_response(npc_id: String, player_input: String) -> String:
	# In production, use local ONNX model for inference
	# For now, use simple keyword matching

	await get_tree().create_timer(0.3).timeout

	var npc_data = NPCManager.load_npc(npc_id)
	var personality = npc_data.get("personality", "neutral")

	# Simple response generation (placeholder for local model)
	var response = _generate_simple_response(player_input, personality)

	return response


# Simple response generation (placeholder)
func _generate_simple_response(player_input: String, personality: String) -> String:
	player_input = player_input.to_lower()

	# Keyword-based responses
	var responses = {
		"greeting": ["你好。", "有什么事吗？", "我在听。"],
		"question": ["这个问题很有意思...", "让我想想...", "我不能说太多，但..."],
		"accusation": ["你怎么能这么想？", "这不是真的！", "你有证据吗？"],
		"default": ["嗯...", "我明白了。", "继续说。"]
	}

	if "谁" in player_input or "什么" in player_input or "为什么" in player_input:
		return _pick_random(responses.question)
	elif "你好" in player_input or "嗨" in player_input:
		return _pick_random(responses.greeting)
	elif "你" in player_input and ("凶手" in player_input or "杀人" in player_input):
		return _pick_random(responses.accusation)
	else:
		return _pick_random(responses.default)


func _pick_random(arr: Array) -> String:
	return arr[randi() % arr.size()]


# ===========================================================
# HTTP Client - Cloud Requests
# ===========================================================

func _send_cloud_request(request: Dictionary) -> Dictionary:
	if cloud_api_key == "":
		print("[AIService] API key not configured")
		return {}

	var http = HTTPRequest.new()
	add_child(http)

	var headers = [
		"Content-Type: application/json",
		"Authorization: Bearer %s" % cloud_api_key
	]

	var json_body = JSON.stringify(request)
	http.request(cloud_endpoint, headers, HTTPClient.METHOD_POST, json_body)

	var result = await http.request_completed
	http.queue_free()

	if result[0] == HTTPRequest.RESULT_SUCCESS:
		var response = JSON.parse_string(result[3].get_string_from_utf8())
		return response
	else:
		print("[AIService] Request failed: %d" % result[0])
		return {}


# Parse story response from LLM
func _parse_story_response(response: Dictionary) -> Dictionary:
	var content = response.get("choices", [{}])[0].get("message", {}).get("content", "{}")
	var story = JSON.parse_string(content)

	if story is Dictionary:
		return story
	else:
		return StoryManager._create_sample_story()


# Parse NPC response from LLM
func _parse_npc_response(response: Dictionary) -> Dictionary:
	var content = response.get("choices", [{}])[0].get("message", {}).get("content", "{}")
	var npc = JSON.parse_string(content)

	if npc is Dictionary:
		return npc
	else:
		return {}


# Create default NPC (fallback)
func _create_default_npc(npc_id: String) -> Dictionary:
	return {
		"id": npc_id,
		"name": "未知角色",
		"role": "路人",
		"background": "一个神秘的人物。",
		"personality": "中性",
		"expressions": {"neutral": "normal"}
	}


# Generate cache key
func _generate_cache_key(prompt: Dictionary) -> String:
	return str(hash(JSON.stringify(prompt)))

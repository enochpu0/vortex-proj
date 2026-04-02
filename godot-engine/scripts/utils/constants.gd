extends Node
class_name Constants

# ===========================================================
# Game Constants
# ===========================================================

# Game Info
const GAME_TITLE := "Mystery Files"
const GAME_VERSION := "1.0.0"
const GAME_VERSION_CODE := 1

# Paths
const PATH_SCENES := "res://scenes/"
const PATH_SCRIPTS := "res://scripts/"
const PATH_RESOURCES := "res://resources/"
const PATH_DATA := "res://data/"
const PATH_SAVES := "user://saves/"

# Scene Paths
const SCENE_MAIN_MENU := "res://scenes/ui/main_menu.tscn"
const SCENE_EXPLORE := "res://scenes/ui/explore.tscn"
const SCENE_DIALOGUE := "res://scenes/ui/dialogue.tscn"
const SCENE_ENDING := "res://scenes/ui/ending.tscn"
const SCENE_ARCHIVE := "res://scenes/ui/archive.tscn"
const SCENE_SETTINGS := "res://scenes/ui/settings.tscn"

# Audio Paths
const PATH_AUDIO_BGM := "res://resources/audio/bgm/"
const PATH_AUDIO_SFX := "res://resources/audio/sfx/"
const PATH_AUDIO_AMBIENT := "res://resources/audio/ambient/"

# SFX Keys
const SFX_BUTTON_CLICK := "button_click"
const SFX_DIALOGUE_TYPE := "dialogue_type"
const SFX_CLUE_COLLECT := "clue_collect"
const SFX_TRANSITION := "transition"

# BGM Keys
const BGM_MAIN_MENU := "main_theme"
const BGM_EXPLORE := "mystery_1"
const BGM_DIALOGUE := "tension"
const BGM_ENDING := "ending"

# Settings
const DEFAULT_LANGUAGE := "zh"
const DEFAULT_BGM_VOLUME := 0.0
const DEFAULT_SFX_VOLUME := 0.0
const DEFAULT_AMBIENT_VOLUME := -5.0

# Gameplay
const MAX_CLUES := 10
const MAX_DIALOGUE_HISTORY := 50
const AUTO_SAVE_INTERVAL := 300  # seconds

# UI
const TYPEWRITER_DEFAULT_DELAY := 0.03
const FADE_IN_DURATION := 0.5
const FADE_OUT_DURATION := 0.3

# Voice
const VOICE_MAX_DURATION := 30.0  # seconds
const VOICE_SILENCE_TIMEOUT := 2.0  # seconds
const VOICE_LANGUAGE_ZH := "zh-CN"
const VOICE_LANGUAGE_EN := "en-US"

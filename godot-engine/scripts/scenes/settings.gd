extends Control

# ===========================================================
# Settings Scene Script
# ===========================================================

@onready var bgm_slider: HSlider = $SettingsContainer/AudioGroup/BGMSlider
@onready var sfx_slider: HSlider = $SettingsContainer/AudioGroup/SFXSlider
@onready var language_select: OptionButton = $SettingsContainer/VoiceGroup/LanguageSelect
@onready var clear_save_button: Button = $SettingsContainer/DataGroup/ClearSaveButton

# Settings state
var settings_dirty: bool = false


func _ready() -> void:
	_connect_signals()
	_load_settings()

	print("[Settings] Ready")


# Connect signals
func _connect_signals() -> void:
	var back_button = $Header/BackButton
	if back_button:
		back_button.pressed.connect(_on_back_pressed)

	if bgm_slider:
		bgm_slider.value_changed.connect(_on_bgm_changed)

	if sfx_slider:
		sfx_slider.value_changed.connect(_on_sfx_changed)

	if language_select:
		language_select.item_selected.connect(_on_language_changed)

	if clear_save_button:
		clear_save_button.pressed.connect(_on_clear_save_pressed)


# Load current settings
func _load_settings() -> void:
	if SaveManager:
		# Load volume settings
		var bgm_vol = SaveManager.get_setting("bgm_volume", 0.0)
		var sfx_vol = SaveManager.get_setting("sfx_volume", 0.0)
		var language = SaveManager.get_setting("language", "zh")

		# Update UI
		if bgm_slider:
			bgm_slider.value = bgm_vol * 10

		if sfx_slider:
			sfx_slider.value = sfx_vol * 10

		# Setup language options
		if language_select:
			language_select.clear()
			language_select.add_item("中文", 0)
			language_select.add_item("English", 1)

			if language == "en":
				language_select.selected = 1


# BGM volume changed
func _on_bgm_changed(value: float) -> void:
	var volume = value / 10.0
	if AudioManager:
		AudioManager.set_bgm_volume(volume)
	SaveManager.save_setting("bgm_volume", volume)
	settings_dirty = true


# SFX volume changed
func _on_sfx_changed(value: float) -> void:
	var volume = value / 10.0
	if AudioManager:
		AudioManager.set_sfx_volume(volume)
	SaveManager.save_setting("sfx_volume", volume)
	settings_dirty = true


# Language changed
func _on_language_changed(index: int) -> void:
	var language = "zh" if index == 0 else "en"
	SaveManager.save_setting("language", language)
	settings_dirty = true


# Clear save button pressed
func _on_clear_save_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Show confirmation dialog
	EventBus.ui_show_dialog.emit(
		"确认清除",
		"确定要删除所有存档吗？此操作不可恢复！"
	)


# Confirm clear saves
func _confirm_clear(confirmed: bool) -> void:
	if confirmed:
		if SaveManager:
			SaveManager.delete_save()
			EventBus.ui_show_toast.emit("存档已清除")


# Back button pressed
func _on_back_pressed() -> void:
	if AudioManager:
		AudioManager.play_sfx("button_click")

	# Save any pending settings
	if settings_dirty:
		print("[Settings] Settings saved")

	GameState.go_to_menu()

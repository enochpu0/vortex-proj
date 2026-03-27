extends Node
class_name AudioManagerClass

# ===========================================================
# Audio Manager - Manages BGM, SFX, and ambient sounds
# ===========================================================

# Audio bus names
const BGM_BUS := "BGM"
const SFX_BUS := "SFX"
const AMBIENT_BUS := "Ambient"

# Signals
signal bgm_started(track_id: String)
signal bgm_stopped(track_id: String)
signal sfx_played(sfx_id: String)

# Audio players
var bgm_player: AudioStreamPlayer
var ambient_players: Dictionary = {}

# Current BGM
var current_bgm: String = ""
var is_bgm_paused: bool = false

# Volume levels (dB)
var bgm_volume: float = 0.0
var sfx_volume: float = 0.0
var ambient_volume: float = 0.0

# Default volumes
const DEFAULT_BGM_VOLUME := 0.0
const DEFAULT_SFX_VOLUME := 0.0
const DEFAULT_AMBIENT_VOLUME := -5.0
const DUCKED_BGM_VOLUME := -10.0  # Volume during dialogue


func _ready() -> void:
	_setup_audio_buses()
	_setup_bgm_player()
	print("[AudioManager] Initialized")


# Setup audio buses
func _setup_audio_buses() -> void:
	# Create audio buses if they don't exist
	var buses = [BGM_BUS, SFX_BUS, AMBIENT_BUS]
	for bus_name in buses:
		var bus_index = AudioServer.get_bus_index(bus_name)
		if bus_index == -1:
			# Bus doesn't exist, will be created in Godot editor
			print("[AudioManager] Bus '%s' not found. Please create in Project Settings > Audio." % bus_name)


# Setup BGM player
func _setup_bgm_player() -> void:
	bgm_player = AudioStreamPlayer.new()
	bgm_player.name = "BGMPlayer"
	bgm_player.bus = BGM_BUS
	bgm_player.volume_db = DEFAULT_BGM_VOLUME
	add_child(bgm_player)


# Play BGM with fade in
func play_bgm(track_id: String, fade_in: float = 1.0) -> void:
	if current_bgm == track_id and not is_bgm_paused:
		return

	stop_bgm(fade_in)

	var path = "res://resources/audio/bgm/%s.ogg" % track_id
	if not ResourceLoader.exists(path):
		print("[AudioManager] BGM not found: %s" % path)
		return

	var stream = load(path)
	bgm_player.stream = stream
	bgm_player.volume_db = -80.0  # Start silent
	bgm_player.play()

	current_bgm = track_id
	is_bgm_paused = false

	# Fade in
	if fade_in > 0:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", bgm_volume, fade_in)

	bgm_started.emit(track_id)
	EventBus.emit_bgm_changed(track_id)


# Stop BGM with fade out
func stop_bgm(fade_out: float = 1.0) -> void:
	if not bgm_player.playing:
		return

	if fade_out > 0:
		var tween = create_tween()
		tween.tween_property(bgm_player, "volume_db", -80.0, fade_out)
		tween.tween_callback(bgm_player.stop)
		tween.tween_callback(_on_bgm_stopped)
	else:
		bgm_player.stop()
		_on_bgm_stopped()


func _on_bgm_stopped() -> void:
	if current_bgm != "":
		bgm_stopped.emit(current_bgm)


# Pause BGM
func pause_bgm() -> void:
	if bgm_player.playing:
		is_bgm_paused = true
		bgm_player.stream_paused = true


# Resume BGM
func resume_bgm() -> void:
	if is_bgm_paused:
		is_bgm_paused = false
		bgm_player.stream_paused = false


# Play SFX
func play_sfx(sfx_id: String, volume_db: float = 0.0) -> void:
	var path = "res://resources/audio/sfx/%s.wav" % sfx_id
	if not ResourceLoader.exists(path):
		print("[AudioManager] SFX not found: %s" % path)
		return

	var sfx = AudioStreamPlayer.new()
	sfx.stream = load(path)
	sfx.bus = SFX_BUS
	sfx.volume_db = volume_db
	add_child(sfx)
	sfx.play()

	# Auto-remove after playback
	sfx.finished.connect(func(): sfx.queue_free())

	sfx_played.emit(sfx_id)
	EventBus.emit_sfx_played(sfx_id)


# Play ambient sound
func play_ambient(ambient_id: String, loop: bool = true) -> void:
	var path = "res://resources/audio/ambient/%s.ogg" % ambient_id
	if not ResourceLoader.exists(path):
		print("[AudioManager] Ambient not found: %s" % path)
		return

	# Stop existing ambient of same type
	if ambient_id in ambient_players:
		stop_ambient(ambient_id)

	var player = AudioStreamPlayer.new()
	player.name = ambient_id
	player.stream = load(path)
	player.bus = AMBIENT_BUS
	player.volume_db = ambient_volume
	player.loop = loop
	add_child(player)
	player.play()

	ambient_players[ambient_id] = player
	EventBus.emit_ambient_changed(ambient_id)


# Stop ambient sound
func stop_ambient(ambient_id: String, fade_out: float = 0.5) -> void:
	if ambient_id not in ambient_players:
		return

	var player = ambient_players[ambient_id]

	if fade_out > 0:
		var tween = create_tween()
		tween.tween_property(player, "volume_db", -80.0, fade_out)
		tween.tween_callback(func(): player.queue_free())
	else:
		player.queue_free()

	ambient_players.erase(ambient_id)


# Stop all ambients
func stop_all_ambients() -> void:
	for ambient_id in ambient_players:
		stop_ambient(ambient_id, 0.5)


# Set volumes
func set_bgm_volume(volume: float) -> void:
	bgm_volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(BGM_BUS), volume)


func set_sfx_volume(volume: float) -> void:
	sfx_volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(SFX_BUS), volume)


func set_ambient_volume(volume: float) -> void:
	ambient_volume = volume
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(AMBIENT_BUS), volume)


# Duck BGM for dialogue
func duck_bgm_for_dialogue() -> void:
	var tween = create_tween()
	tween.tween_property(bgm_player, "volume_db", DUCKED_BGM_VOLUME, 0.3)


# Restore BGM volume
func restore_bgm_volume() -> void:
	var tween = create_tween()
	tween.tween_property(bgm_player, "volume_db", bgm_volume, 0.5)

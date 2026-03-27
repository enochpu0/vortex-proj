extends Node
class_name Logger

# ===========================================================
# Logger - Simple logging utility
# ===========================================================

enum LogLevel {
	DEBUG,
	INFO,
	WARNING,
	ERROR
}

static var log_level: LogLevel = LogLevel.INFO
static var enable_timestamp: bool = true
static var log_to_file: bool = false
static var log_file_path: String = "user://game.log"


static func debug(message: String) -> void:
	if log_level <= LogLevel.DEBUG:
		_log("DEBUG", message)


static func info(message: String) -> void:
	if log_level <= LogLevel.INFO:
		_log("INFO", message)


static func warn(message: String) -> void:
	if log_level <= LogLevel.WARNING:
		_log("WARN", message)


static func error(message: String) -> void:
	if log_level <= LogLevel.ERROR:
		_log("ERROR", message)


static func _log(level: String, message: String) -> void:
	var timestamp = ""
	if enable_timestamp:
		timestamp = "[%s] " % Time.get_datetime_string()

	var log_message = "%s[%s] %s" % [timestamp, level, message]
	print(log_message)

	if log_to_file:
		_write_to_file(log_message)


static func _write_to_file(message: String) -> void:
	var file = FileAccess.open(log_file_path, FileAccess.READ_WRITE)
	if not file:
		file = FileAccess.open(log_file_path, FileAccess.WRITE)

	if file:
		file.seek_end()
		file.store_line(message)
		file.close()


static func clear_log() -> void:
	if FileAccess.file_exists(log_file_path):
		DirAccess.remove_absolute(log_file_path)

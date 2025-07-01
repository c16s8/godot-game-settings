@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent
## and global instance to function.

## Can be used to react to a setting being applied. [param setting] is
## the [member GGSSetting.key] name of the setting resource this is emitted
## from.
signal setting_applied(setting: String, value: Variant)

@export_group("Input Preferences")
## Time the input component listens for input. When this expires, it
## automatically stops listening for input.
@export_range(0.001, 4096, 0.001, "exp", "suffix:s")
var listen_time: float = 3.0

## Delay before accepting the chosen input. Mainly used to give enough time
## to process modifiers for keyboard and mouse events.[br]
## If you don't plan to accept modifiers, you can set this to its minimum
## value.[br]
## If you do, choosing a number that's too low may prevent the users from
## inputting a key with modifier.
@export_range(0.001, 4096, 0.001, "exp", "suffix:s")
var accept_delay: float = 0.33

## The button text animation speed when an input component is listening for
## input. A higher value means slower animation.
@export var anim_speed: float = 1.5

var _file_path: String
var _file: ConfigFile = ConfigFile.new()
var _settings: Array[GGSSetting]

## Used to group and access audio players (e.g. [code]GGS.Audio.Interact[/code])
@onready var Audio: Node = $Audio


func _ready() -> void:
	_settings = _get_all_settings()
	_file_init()
	_file_clean_up()

	if not Engine.is_editor_hint():
		_apply_all()


func _get_all_settings() -> Array[GGSSetting]:
	var result: Array[GGSSetting]
	var settings: PackedStringArray = _get_dir_settings(settings_dir)
	for setting: String in settings:
		# ".remap" is trimmed to prevent resource loader errors when
		# the project is exported.
		var obj: Resource = load(setting.trim_suffix(".remap"))
		if obj is not GGSSetting:
			continue

		result.append(obj)

	return result


func _get_dir_settings(path: String) -> PackedStringArray:
	var result: PackedStringArray
	var dir_access: DirAccess = DirAccess.open(path)

	for file: String in dir_access.get_files():
		if file.get_extension() == "gd" or file.get_extension() == "uid":
			continue

		var file_path: String = path.path_join(file)
		result.append(file_path)

	for dir: String in dir_access.get_directories():
		var dir_path: String = path.path_join(dir)
		var dir_settings: PackedStringArray = _get_dir_settings(dir_path)
		result.append_array(dir_settings)

	return result


func _file_init() -> void:
	_file_path = BASE_PATH.path_join(config_file)
	if FileAccess.file_exists(_file_path):
		_file.load(_file_path)

	_file.save(_file_path)


# Removes unused keys and adds missing ones to the save file.
func _file_clean_up() -> void:
	# 1. Save the current keys in a temp variable for later.
	var temp: Dictionary
	for section: String in _file.get_sections():
		temp[section] = {}
		for key: String in _file.get_section_keys(section):
			temp[section][key] = _file.get_value(section, key)

	# 2. Clear the file.
	_file.clear()

	# 3. Recreate keys from the default value of settings.
	for setting: GGSSetting in _settings:
		if setting.key.is_empty():
			continue

		_file.set_value(setting.section, setting.key, setting.default)

	# 4. If the key exists in this new file, use temp to restore the value
	# it had before clearing the file.
	for section: String in temp:
		if not _file.has_section(section):
			continue

		for key: String in temp[section]:
			if not _file.has_section_key(section, key):
				continue

			_file.set_value(section, key, temp[section][key])

	_file.save(_file_path)


func _apply_all() -> void:
	for setting: GGSSetting in _settings:
		var value: Variant = get_value(setting)
		setting.apply(value)

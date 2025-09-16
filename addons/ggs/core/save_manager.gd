@tool
extends RefCounted
class_name GGSSaveManager

const _FILE_PATH: String = "user://settings.cfg"


## Saves the value of the given setting to the disc.
static func save_setting_value(setting: GGSSetting, value: Variant) -> void:
	var file: ConfigFile = _get_file()
	file.set_value(setting.section, setting.key, value)
	file.save(_FILE_PATH)


## Loads the value of the given setting from the disc.
static func load_setting_value(setting: GGSSetting) -> Variant:
	var file: ConfigFile = _get_file()
	return file.get_value(setting.section, setting.key, setting.default)


## Gets all settings located in the settings directory (recursive).
static func get_all_settings() -> Array[GGSSetting]:
	var result: Array[GGSSetting]
	
	var settings: PackedStringArray = _get_settings_in_dir(GGS.plugin_settings.settings_directory)
	for setting: String in settings:
		# ".remap" is trimmed to prevent resource loader errors when the project is exported.
		var obj: Resource = load(setting.trim_suffix(".remap"))
		if obj is not GGSSetting:
			continue

		result.append(obj)
	
	return result


## Removes unused keys and adds missing ones to the save file.
static func clean_up_file() -> void:
	var file: ConfigFile = _get_file()

	# 1. Save the current keys in a temp variable for later.
	var temp: Dictionary[String, Dictionary]
	for section: String in file.get_sections():
		temp[section] = {}
		for key: String in file.get_section_keys(section):
			temp[section][key] = file.get_value(section, key)

	# 2. Clear the file.
	file.clear()

	# 3. Recreate keys from the default value of settings.
	for setting: GGSSetting in get_all_settings():
		if setting.key.is_empty():
			continue
		file.set_value(setting.section, setting.key, setting.default)

	# 4. If the key exists in this new file, use temp to restore the value it had before clearing the file.
	for section: String in temp:
		if not file.has_section(section):
			continue
		for key: String in temp[section]:
			if not file.has_section_key(section, key):
				continue
			file.set_value(section, key, temp[section][key])
	
	file.save(_FILE_PATH)


static func _get_file() -> ConfigFile:
	var file: ConfigFile = ConfigFile.new()
	if FileAccess.file_exists(_FILE_PATH):
		file.load(_FILE_PATH)
	else:
		file.save(_FILE_PATH)
	return file


static func _get_settings_in_dir(path: String) -> PackedStringArray:
	var result: PackedStringArray
	var dir_access: DirAccess = DirAccess.open(path)

	for file: String in dir_access.get_files():
		if file.get_extension() != "tres":
			continue

		var file_path: String = path.path_join(file)
		result.append(file_path)

	for dir: String in dir_access.get_directories():
		var dir_path: String = path.path_join(dir)
		var dir_settings: PackedStringArray = _get_settings_in_dir(dir_path)
		result.append_array(dir_settings)

	return result

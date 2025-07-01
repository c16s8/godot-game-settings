@tool
extends RefCounted
class_name GGSSaveManager

const _BASE_PATH: String = "user://"


static func save_setting(setting: GGSSetting, value: Variant) -> void:
    _file.set_value(setting.section, setting.key, value)
    _file.save(_file_path)


## Loads the current value of the provided [param setting] from the save
## file. Returns the setting's default if its key doesn't exist.
func get_value(setting: GGSSetting) -> Variant:
    return _file.get_value(setting.section, setting.key, setting.default)


static func _get_file() -> ConfigFile:
    var file: ConfigFile = ConfigFile.new()
    var file_name: String = load(GGSPluginSettings.UID).save_file
    var path: String = _BASE_PATH.path_join(file_name)
    if FileAccess.file_exists(path):
        file.load(path)
        return file
    
    file.save(_file_path)
    return file


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


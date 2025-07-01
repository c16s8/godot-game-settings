@tool
extends Resource
class_name GGSPluginSettings
## Resource class for storing and managing GGS settings.

## The UID of the plugin settings resource that comes with GGS by default.
const UID: String = "uid://dhewfdfjnlrvc"

@export_group("Directories and Files")
## The directory where the game setting resources are located.
@export_dir var settings_directory: String = "res://ggs/game_settings"
## File name and extension that will be used to save and load game setting values.
@export var save_file: String = "settings.cfg"

@export_group("Joypad")
## The type that will be used when retrieving text and glyph for joypad input events.
@export_enum("Xbox","Playstation","Switch") var joypad_device: String = "Xbox"
@export_file("*.tres") var text_db: String = "res://ggs/plugin/default_text_db.tres"
@export_file("*.tres") var glyph_db: String = "res://ggs/plugin/default_glyph_db.tres"

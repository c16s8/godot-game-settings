@tool
extends Resource
class_name GGSPluginSettings
## Resource class for storing and managing GGS settings.

## The UID of the plugin settings resource that comes with GGS by default.
const UID: String = "uid://dhewfdfjnlrvc"

## The directory where the game setting resources are located.
@export_dir var settings_directory: String = "res://ggs/game_settings"

@export_group("Joypad")
## The type that will be used when retrieving text and glyph for joypad input events.
@export_enum("Xbox","Playstation","Switch") var joypad_device: String = "Xbox"
@export_file("*.tres") var text_db: String = "res://ggs/plugin/default_text_db.tres"
@export_file("*.tres") var glyph_db: String = "res://ggs/plugin/default_glyph_db.tres"

@export_group("Components")
@export_subgroup("Input Button", "input_btn_")
## The time the input component listens for input before automatically stopping.
@export_range(0.001, 4096, 0.001, "exp", "suffix:s") var input_btn_listen_time: float = 3.0

## Delay before accepting the chosen input. Mainly used to create enough time for keyboard and mouse modifiers to get processed.[br]
## If you don't plan to accept modifiers, you can set this to its minimum value. If you do, choosing a number that's too low may
## prevent the users from using modifiers.
@export_range(0.001, 4096, 0.001, "exp", "suffix:s") var input_btn_accept_delay: float = 0.33

## The delay between each animation frame when the input component is listening. Higher values mean slower animation.
@export var input_btn_anim_frame_delay: float = 1.5
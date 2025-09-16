@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent and global instance to function.

## Emitted when any setting is applied.
signal setting_applied(setting: GGSSetting, value: Variant)

## The plug settings instance that should be used
@export var plugin_settings: GGSPluginSettings

## Audio players used to play the sound effects of the user interface components.
@export_group("Audio Players")
@export var audio_mouse_entered: AudioStreamPlayer
@export var audio_focus_entered: AudioStreamPlayer
@export var audio_activated: AudioStreamPlayer


func _ready() -> void:
	GGSSaveManager.clean_up_file()
	if not Engine.is_editor_hint():
		_apply_all()


func _apply_all() -> void:
	for setting: GGSSetting in GGSSaveManager.get_all_settings():
		var value: Variant = GGSSaveManager.load_setting_value(setting)
		setting.apply(value)
		setting_applied.emit(setting, value)

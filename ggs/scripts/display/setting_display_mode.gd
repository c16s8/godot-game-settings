@tool
extends GGSSetting
class_name SettingDisplayMode
## Changes display mode between fullscreen, borderless, and windowed.

## A setting that can handle window size. Used to set the game window to the correct size after its state changes.
@export var size_setting: GGSSetting


func _init() -> void:
	type = TYPE_INT
	hint = PROPERTY_HINT_ENUM
	hint_string = "Fullscreen,Borderless,Windowed"
	default = 2
	section = "display"


func apply(value: int) -> void:
	var window_mode: DisplayServer.WindowMode
	match value:
		0:
			window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		1:
			window_mode = DisplayServer.WINDOW_MODE_FULLSCREEN
		2:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)

	if size_setting != null:
		var size_value: int = GGSSaveManager.load_setting_value(size_setting)
		GGS.setting_applied.emit(size_setting, size_value)
		size_setting.apply(size_value)

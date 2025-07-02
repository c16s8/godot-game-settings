@tool
extends GGSSetting
class_name SettingDisplayFullscreen
## Toggles window fullscreen mode.

## A setting that can handle window size. Used to set the game window to the correct size after its fullscreen state changes.
@export var size_setting: GGSSetting


func _init() -> void:
	type = TYPE_BOOL
	default = false
	section = "display"


func apply(value: bool) -> void:
	var window_mode: DisplayServer.WindowMode
	match value:
		true:
			window_mode = DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN
		false:
			window_mode = DisplayServer.WINDOW_MODE_WINDOWED
	DisplayServer.window_set_mode(window_mode)

	if size_setting != null:
		var size_value: int = GGSSaveManager.load_setting_value(size_setting)
		GGS.setting_applied.emit(size_setting, size_value)
		size_setting.apply(size_value)

@tool
extends GGSSetting
class_name SettingVSync
## Changes VSync mode.

func _init() -> void:
	type = TYPE_INT
	hint = PROPERTY_HINT_ENUM
	hint_string = "Disabled,Enabled,Adaptive,Mailbox"
	default = DisplayServer.VSYNC_ENABLED
	section = "display"


func apply(value: int) -> void:
	DisplayServer.window_set_vsync_mode(value)

@tool
extends GGSSetting
class_name SettingDisplayScale
## Sets the window scale. The window will be resized by multiplying its dimensions by a flat number.

## List of available scales.
@export var scales: Array[float]: set = _set_scales


func _init() -> void:
	type = TYPE_INT
	hint = PROPERTY_HINT_ENUM
	default = 0
	section = "display"


func _set_scales(value: Array[float]) -> void:
	scales = value

	if Engine.is_editor_hint():
		hint_string = ",".join(_get_scale_strings())
		notify_property_list_changed()


func apply(value: int) -> void:
	var scale: float = scales[value]
	var base_w: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	var base_h: int = ProjectSettings.get_setting("display/window/size/viewport_height")
	var size: Vector2 = Vector2(base_w, base_h) * scale
	GGSWindowUtils.clamp_to_screen()
	DisplayServer.window_set_size(size)
	GGSWindowUtils.center()


func _get_scale_strings() -> PackedStringArray:
	var result: PackedStringArray = []
	for scale: float in scales:
		result.append("x%s" % [scale])
	return result

@tool
extends GGSSetting
class_name SettingDisplaySize
## Sets the window size. The window will be resized by setting its size to provided values.

## List of available sizes.
@export var sizes: Array[Vector2]: set = _set_sizes


func _init() -> void:
	type = TYPE_INT
	hint = PROPERTY_HINT_ENUM
	default = 0
	section = "display"


func _set_sizes(value: Array[Vector2]) -> void:
	sizes = value

	if Engine.is_editor_hint():
		hint_string = ",".join(_get_size_strings())
		notify_property_list_changed()


func apply(value: int) -> void:
	var size: Vector2 = sizes[value]
	GGSWindowUtils.clamp_to_screen()
	DisplayServer.window_set_size(size)
	GGSWindowUtils.center()


func _get_size_strings() -> PackedStringArray:
	var result: PackedStringArray
	for size: Vector2 in sizes:
		var formatted_size: String = str(size).trim_prefix("(").trim_suffix(")").replace(",", " x")
		result.append(formatted_size)
	return result

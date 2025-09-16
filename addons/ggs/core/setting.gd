@tool
@abstract
extends Resource
class_name GGSSetting
## Resource that contains the necessary information for a specific game setting such as its default
## value or its script.

## The key name used to save and load the value. The setting will not be saved if this is empty.
@export var key: String = "": set = _set_key

## The section name used to save and load the value. It can be empty.
@export var section: String = ""

## Default value of the setting.
var default: Variant = false: set = _set_default

## The value type this setting uses.
var type: Variant.Type = TYPE_BOOL

## Property hint of [member default]. Use it to customize how [member default] is exported.
var hint: PropertyHint = PROPERTY_HINT_NONE

## Property hint string of [member default]. Use it alongside [member hint] to customize how
## [member default] is exported.
var hint_string: String = ""


func _get_property_list() -> Array:
	var properties: Array
	properties.append_array([
		{
			"name": "default",
			"type": type,
			"hint": hint,
			"hint_string": hint_string,
		},
	])
	return properties


func _set_default(value: Variant) -> void:
	default = value
	if Engine.is_editor_hint() and not key.is_empty():
		GGSSaveManager.save_setting_value(self, value)


func _set_key(value: String) -> void:
	key = value
	resource_name = value


## This method is called when a setting needs to be applied. In other words, it should contain the setting logic.
@abstract func apply(value) -> void

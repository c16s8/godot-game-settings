@tool
extends GGSSetting
class_name SettingInputRebind
## Rebinds the chosen input event of a specific input action.

## The action to be rebinded.
var action: String: set = _set_action

## Index of the input event to be replaced.
var event_index: int: set = _set_event_index


func _init() -> void:
	type = TYPE_ARRAY
	default = []
	section = "input"


func _get_property_list() -> Array:
	return [
		{
			"name": "action",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_INPUT_NAME,
		},
		{
			"name": "event_index",
			"type": TYPE_INT,
			"usage": _get_usage(),
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(_get_event_list()),
		},
	]


func _set_action(value: String) -> void:
	action = value
	event_index = 0
	notify_property_list_changed()


func _set_event_index(value: int) -> void:
	event_index = value

	var events: Array = GGSInputUtils.action_get_events(action)
	if events.is_empty():
		default = []
		return
	default = GGSInputUtils.serialize_event(events[value])


func apply(value: Array) -> void:
	var event: InputEvent = GGSInputUtils.deserialize_event(value)

	var new_events: Array[InputEvent] = InputMap.action_get_events(action)
	new_events.remove_at(event_index)
	new_events.insert(event_index, event)

	InputMap.action_erase_events(action)
	for input_event: InputEvent in new_events:
		InputMap.action_add_event(action, input_event)


func _get_usage() -> int:
	if action.is_empty() or GGSInputUtils.action_get_events(action).is_empty():
		return PROPERTY_USAGE_DEFAULT | PROPERTY_USAGE_READ_ONLY
	else:
		return PROPERTY_USAGE_DEFAULT


func _get_event_list() -> PackedStringArray:
	if action.is_empty():
		return ["No action is selected."]
	
	var events: Array = GGSInputUtils.action_get_events(action)
	if events.is_empty():
		return ["Selected action has no events."]

	var event_names: PackedStringArray
	var event_idx: int = 0
	for event: InputEvent in events:
		var event_text: String = GGSInputUtils.event_get_text(event)
		event_names.append("%d. %s" % [event_idx, event_text])
		event_idx += 1
	
	return event_names

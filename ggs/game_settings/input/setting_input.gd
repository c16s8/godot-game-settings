@tool
extends GGSSetting

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
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(_get_current_action_events()),
		},
	]


func _set_action(value: String) -> void:
	action = value
	event_index = 0
	notify_property_list_changed()


func _set_event_index(value: int) -> void:
	event_index = value
	var target_event: InputEvent = GGSInputUtils.action_get_events(action)[value]
	default = GGSInputUtils.serialize_event(target_event)


func apply(value: Array, ..._extra_args: Array) -> void:
	var event: InputEvent = GGSInputUtils.deserialize_event(value)

	var new_events: Array[InputEvent] = InputMap.action_get_events(action)
	new_events.remove_at(event_index)
	new_events.insert(event_index, event)

	InputMap.action_erase_events(action)
	for input_event: InputEvent in new_events:
		InputMap.action_add_event(action, input_event)

	# GGS.setting_applied.emit(key, value)


func _get_current_action_events() -> PackedStringArray:
	if action.is_empty():
		return []

	var event_names: PackedStringArray
	var events: Array = GGSInputUtils.action_get_events(action)
	for event: InputEvent in events:
		var event_text: String = GGSInputUtils.event_get_text(event)
		event_names.append(event_text)

	return event_names

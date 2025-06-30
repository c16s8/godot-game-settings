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
			"hint_string": ",".join(_action_get_events()),
		},
	]


func _set_action(value: String) -> void:
	action = value
	event_index = 0
	notify_property_list_changed()


func _set_event_index(value: int) -> void:
	event_index = value
	var input_map: Dictionary = GGSInputUtils.get_input_map()
	var target_event: InputEvent = input_map[action][event_index]
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


func _action_get_events() -> PackedStringArray:
	var _ggsinputhelper: GGSInputUtils = GGSInputUtils.new()

	var input_map: Dictionary = GGSInputUtils.get_input_map()

	var events: PackedStringArray
	if action.is_empty():
		return []

	for event: InputEvent in input_map[action]:
		var event_text: String = _ggsinputhelper.event_get_text(event)
		events.append(event_text)

	return events

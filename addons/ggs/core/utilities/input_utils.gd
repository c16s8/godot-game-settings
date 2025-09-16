@tool
extends RefCounted
class_name GGSInputUtils
## Provides various input utilities.

enum InputType {KEYBOARD, MOUSE, JOYPAD_BUTTON, JOYPAD_MOTION}

enum AxisDirection {
	LEFT_STICK_LEFT, LEFT_STICK_RIGHT, LEFT_STICK_UP, LEFT_STICK_DOWN,
	RIGHT_STICK_LEFT, RIGHT_STICK_RIGHT, RIGHT_STICK_UP, RIGHT_STICK_DOWN,
	LEFT_TRIGGER, RIGHT_TRIGGER,
}

const _AXIS_TO_DIRECTION: Dictionary[JoyAxis, Dictionary] = {
	JOY_AXIS_LEFT_X: {
		-1: AxisDirection.LEFT_STICK_LEFT,
		1: AxisDirection.LEFT_STICK_RIGHT,
	},
	JOY_AXIS_LEFT_Y: {
		-1: AxisDirection.LEFT_STICK_UP,
		1: AxisDirection.LEFT_STICK_DOWN,
	},
	JOY_AXIS_RIGHT_X: {
		-1: AxisDirection.RIGHT_STICK_LEFT,
		1: AxisDirection.RIGHT_STICK_RIGHT,
	},
	JOY_AXIS_RIGHT_Y: {
		-1: AxisDirection.RIGHT_STICK_UP,
		1: AxisDirection.RIGHT_STICK_DOWN,
	},
	JOY_AXIS_TRIGGER_LEFT: {
		1: AxisDirection.LEFT_TRIGGER,
	},
	JOY_AXIS_TRIGGER_RIGHT: {
		1: AxisDirection.RIGHT_TRIGGER,
	},
}

const JOYPAD_DEVICE_LAYOUTS: Dictionary = {
	"XInput Gamepad": "xbox",
	"Xbox Series Controller": "xbox",
	"Sony DualSense": "playstation",
	"PS5 Controller": "playstation",
	"PS4 Controller": "playstation",
	"Switch": "switch",
}

const MODIFIERS_MASK: int = KEY_MASK_SHIFT | KEY_MASK_CTRL | KEY_MASK_ALT


## Serializes the given event by saving its key properties in an array.
static func serialize_event(event: InputEvent) -> Array:
	var type: int = -1
	var id: int = -1
	var axis_dir: int = 0

	if event is InputEventKey:
		type = InputType.KEYBOARD
		id = event.physical_keycode | event.get_modifiers_mask()

	if event is InputEventMouseButton:
		type = InputType.MOUSE
		id = event.button_index | event.get_modifiers_mask()

	if event is InputEventJoypadButton:
		type = InputType.JOYPAD_BUTTON
		id = event.button_index

	if event is InputEventJoypadMotion:
		type = InputType.JOYPAD_MOTION
		id = event.axis
		axis_dir = event.axis_value

	return [type, id, axis_dir]


## Recreates an event serialized via [method serialize_event].
static func deserialize_event(data: Array) -> InputEvent:
	var type: int = data[0]
	var id: int = data[1]
	var axis_dir: int = data[2]

	var event: InputEvent
	if type == InputType.KEYBOARD:
		event = InputEventKey.new()
		event.physical_keycode = id & ~MODIFIERS_MASK
		event.shift_pressed = bool(id & KEY_MASK_SHIFT)
		event.ctrl_pressed = bool(id & KEY_MASK_CTRL)
		event.alt_pressed = bool(id & KEY_MASK_ALT)

	if type == InputType.MOUSE:
		event = InputEventMouseButton.new()
		event.button_index = id & ~MODIFIERS_MASK
		event.shift_pressed = bool(id & KEY_MASK_SHIFT)
		event.ctrl_pressed = bool(id & KEY_MASK_CTRL)
		event.alt_pressed = bool(id & KEY_MASK_ALT)

	if type == InputType.JOYPAD_BUTTON:
		event = InputEventJoypadButton.new()
		event.button_index = id

	if type == InputType.JOYPAD_MOTION:
		event = InputEventJoypadMotion.new()
		event.axis = id
		event.axis_value = axis_dir

	return event


## Retrieves the input events associated with the given action. Unlike [method InputMap.action_get_events()], it works in the
## editor.
static func action_get_events(action: String) -> Array:
	var project_file: ConfigFile = ConfigFile.new()
	project_file.load("res://project.godot")
	var action_properties: Dictionary = project_file.get_value("input", action)
	var action_events: Array = action_properties["events"]
	return action_events


## Returns a string representation of the event. Uses the [GGSInputTextDB] selected in the plugin settings for its text data.
## The returned text for joypad events depends on the joypad device selected in the plugin settings.
static func event_get_text(event: InputEvent) -> String:
	var text: String = "INVALID EVENT"
	var db: GGSInputTextDB = GGS.plugin_settings.text_db

	if event is InputEventKey:
		var keycode_with_modifiers: int = event.get_physical_keycode_with_modifiers()
		text = OS.get_keycode_string(keycode_with_modifiers)

	if event is InputEventMouseButton:
		var modifiers_string: String = _event_get_modifiers_string(event)
		text = modifiers_string + db.mouse[event.button_index]

	if event is InputEventJoypadButton:
		var layout: String = _joypad_get_device_layout(event)
		var property: String = "%s_button"%[layout]
		text = db.get(property)[event.button_index]

	if event is InputEventJoypadMotion:
		var layout: String = _joypad_get_device_layout(event)
		var property: String = "%s_axis"%[layout]
		var axis_direction: AxisDirection = _event_get_axis_direction(event)
		text = db.get(property)[axis_direction]

	return text


## Returns an image representation of the event. Uses  the [GGSInputGlyphDB] selected in the plugin settings for its image data.
## The returned image for joypad events depends on the joypad device selected in the plugin settings.
static func event_get_glyph(event: InputEvent) -> Texture2D:
	var db: GGSInputGlyphDB = GGS.plugin_settings.glyph_db
	var glyph: Texture2D = null

	if event is InputEventMouseButton:
		glyph = db.mouse[event.button_index]

	if event is InputEventJoypadButton:
		var layout: String = _joypad_get_device_layout(event)
		var property: String = "%s_button"%[layout]
		glyph = db.get(property)[event.button_index]

	if event is InputEventJoypadMotion:
		var layout: String = _joypad_get_device_layout(event)
		var property: String = "%s_axis"%[layout]
		var axis_direction: AxisDirection = _event_get_axis_direction(event)
		glyph = db.get(property)[axis_direction]

	return glyph


static func _event_get_modifiers_string(event: InputEventWithModifiers) -> String:
	var modifiers: PackedStringArray
	if event.shift_pressed:
		modifiers.append("Shift")

	if event.ctrl_pressed:
		modifiers.append("Ctrl")

	if event.alt_pressed:
		modifiers.append("Alt")

	if modifiers.is_empty():
		return ""
	else:
		return "+".join(modifiers) + "+"


static func _event_get_axis_direction(event: InputEventJoypadMotion) -> AxisDirection:
	var axis_direction: int = sign(event.axis_value)
	return _AXIS_TO_DIRECTION[event.axis][axis_direction]


static func _joypad_get_device_layout(event: InputEvent) -> String:
	var device_name: String = Input.get_joy_name(event.device)
	if JOYPAD_DEVICE_LAYOUTS.has(device_name):
		return JOYPAD_DEVICE_LAYOUTS[device_name]
	else:
		return GGS.plugin_settings.joypad_fallback_layout.to_lower()

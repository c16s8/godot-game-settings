@tool
@icon("res://ggs/components/input_btn/input_btn.svg")
extends GGSComponent

enum State {NORMAL, LISTENING}
enum AcceptedTypes {
	KEYBOARD = 1 << 0,
	MOUSE = 1 << 1,
	JOYPAD_BUTTON = 1 << 2,
	JOYPAD_AXIS = 1 << 3,
}

const TEXT_ANIM: PackedStringArray = [".", "..", "...", "."]

## Types of input this component listens to.
@export_flags("Keyboard", "Mouse", "Joypad Button", "Joypad Axis") var _accepted_types: int = 1

## Whether modifiers should be accepted. Only relevant for keyboard and mouse events.
@export var _accept_modifiers: bool

## Whether the component should show use glyphs to show mouse and joypad events. Uses the [GGSGlyphDB] select in the plugin
## settings for its image data.
@export var _use_glyph: bool

var _state: State = State.NORMAL: set = _set_state
var _new_event: InputEvent
var _tween: Tween
var _anim_frame: int: set = _set_anim_frame

@onready var _btn: Button = $Btn
@onready var _listen_timer: Timer = $ListenTime
@onready var _accept_delay: Timer = $AcceptDelay


func _ready() -> void:
	compatible_types = [TYPE_ARRAY]
	if Engine.is_editor_hint():
		return

	_btn.toggled.connect(_on_btn_toggled)
	_btn.mouse_entered.connect(_on_btn_mouse_entered)
	_btn.focus_entered.connect(_on_btn_focus_entered)
	_listen_timer.timeout.connect(_on_listen_timer_timeout)
	_accept_delay.timeout.connect(_on_accept_delay_timeout)
	Input.joy_connection_changed.connect(_on_input_joy_connection_changed)

	init_value()
	_listen_timer.wait_time = GGS.plugin_settings.input_btn_listen_time
	_accept_delay.wait_time = GGS.plugin_settings.input_btn_accept_delay


func _input(event: InputEvent) -> void:
	if _state != State.LISTENING:
		return

	if not _event_is_acceptable(event):
		return

	_new_event = event
	accept_event()
	_accept_delay.start()


func _set_state(new_state: State) -> void:
	_state = new_state
	match new_state:
		State.NORMAL:
			_btn.set_pressed_no_signal(false)
			_tween.kill()
			_update_btn_display()
		State.LISTENING:
			_btn.icon = null
			_tween = create_tween()
			_tween.set_loops()
			_tween.tween_property(
				self,
				"_anim_frame",
				TEXT_ANIM.size() - 1,
				GGS.plugin_settings.input_btn_anim_duration
			).from(0)


func _set_anim_frame(frame: int) -> void:
	_anim_frame = frame
	_btn.text = TEXT_ANIM[frame]


func init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_update_btn_display()


func reset_setting() -> void:
	super()
	_update_btn_display()


func _event_is_acceptable(event: InputEvent) -> bool:
	if (
		event is not InputEventKey
		and event is not InputEventMouseButton
		and event is not InputEventJoypadButton
		and event is not InputEventJoypadMotion
	):
		return false

	if not event.is_pressed():
		return false

	if event.is_echo():
		return false

	if (
		event is InputEventMouse
		and event.double_click
	):
		return false

	if (
		event is InputEventWithModifiers
		and not _accept_modifiers
		and (event.shift_pressed or event.ctrl_pressed or event.alt_pressed)
	):
		return false

	if (
		event is InputEventKey
		and not (_accepted_types & AcceptedTypes.KEYBOARD)
	):
		return false

	if (
		event is InputEventMouseButton
		and not (_accepted_types & AcceptedTypes.MOUSE)
	):
		return false

	if (
		event is InputEventJoypadButton
		and not (_accepted_types & AcceptedTypes.JOYPAD_BUTTON)
	):
		return false

	if (
		event is InputEventJoypadMotion
		and not (_accepted_types & AcceptedTypes.JOYPAD_AXIS)
	):
		return false

	return true



func _accepted_type_has_glyph() -> bool:
	return (
		_accepted_types & AcceptedTypes.MOUSE
		or _accepted_types & AcceptedTypes.JOYPAD_BUTTON
		or _accepted_types & AcceptedTypes.JOYPAD_AXIS
	)


func _update_btn_display() -> void:
	var event: InputEvent = GGSInputUtils.deserialize_event(value)

	if _use_glyph and _accepted_type_has_glyph():
		_btn.icon = GGSInputUtils.event_get_glyph(event)
		if _btn.icon == null:
			_btn.text = GGSInputUtils.event_get_text(event)
		else:
			_btn.text = ""
		return

	_btn.icon = null
	_btn.text = GGSInputUtils.event_get_text(event)


func _on_btn_toggled(toggled_on: bool) -> void:
	if toggled_on:
		GGS.audio_activated.play()
		_state = State.LISTENING
		_listen_timer.start()


func _on_listen_timer_timeout() -> void:
	_state = State.NORMAL


func _on_accept_delay_timeout() -> void:
	_state = State.NORMAL
	value = GGSInputUtils.serialize_event(_new_event)
	if can_apply_on_changed():
		apply_setting()

	_new_event = null
	_update_btn_display()
	GGS.audio_activated.play()


func _on_btn_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		_btn.grab_focus()


func _on_btn_focus_entered() -> void:
	GGS.audio_focus_entered.play()


func _on_input_joy_connection_changed(_device: int, _connected: bool) -> void:
	_update_btn_display()

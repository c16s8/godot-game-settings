@tool
@icon("res://ggs/components/switch/switch.svg")
extends GGSComponent

@onready var _btn: Button = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL]
	if not Engine.is_editor_hint():
		return

	init_value()
	_btn.toggled.connect(_on_btn_toggled)
	_btn.mouse_entered.connect(_on_btn_mouse_entered)
	_btn.focus_entered.connect(_on_btn_focus_entered)


func init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_btn.set_pressed_no_signal(value)


func reset_setting() -> void:
	super()
	_btn.set_pressed_no_signal(value)


func _on_btn_toggled(btn_state: bool) -> void:
	value = btn_state
	GGS.audio_activated.play()
	if can_apply_on_changed():
		apply_setting()


func _on_btn_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		_btn.grab_focus()


func _on_btn_focus_entered() -> void:
	GGS.audio_focus_entered.play()

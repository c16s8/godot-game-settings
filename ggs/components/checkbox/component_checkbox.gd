@tool
@icon("res://ggs/components/checkbox/checkbox.svg")
extends GGSComponent

@onready var _Btn: Button = $Btn


func _ready() -> void:
	compatible_types = [TYPE_BOOL]

	if not Engine.is_editor_hint():
		init_value()
		_Btn.toggled.connect(_on_Btn_toggled)
		_Btn.mouse_entered.connect(_on_Btn_mouse_entered)
		_Btn.focus_entered.connect(_on_Btn_focus_entered)


func init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_Btn.set_pressed_no_signal(value)


func reset_setting() -> void:
	super()
	_Btn.set_pressed_no_signal(value)


func _on_Btn_toggled(btn_state: bool) -> void:
	value = btn_state
	GGS.audio_activation_succeeded.play()
	if can_apply_on_changed():
		apply_setting()


func _on_Btn_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		_Btn.grab_focus()


func _on_Btn_focus_entered() -> void:
	GGS.audio_mouse_exited.play()

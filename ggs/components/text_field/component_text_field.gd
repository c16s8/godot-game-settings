@tool
@icon("res://ggs/components/text_field/text_field.svg")
extends GGSComponent

@onready var _field: LineEdit = $TextField


func _ready() -> void:
	compatible_types = [TYPE_STRING]
	if Engine.is_editor_hint():
		return

	init_value()
	_field.text_submitted.connect(_on_field_text_submitted)
	_field.mouse_entered.connect(_on_field_mouse_entered)
	_field.focus_entered.connect(_on_field_focus_entered)


func init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_field.text = value


func reset_setting() -> void:
	super()
	_field.text = value


func _on_field_text_submitted(submitted_text: String) -> void:
	value = submitted_text
	GGS.audio_activated.play()
	if can_apply_on_changed():
		apply_setting()


func _on_field_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		_field.grab_focus()


func _on_field_focus_entered() -> void:
	GGS.audio_focus_entered.play()
@tool
@icon("res://ggs/components/spinbox/spinbox.svg")
extends GGSComponent

@onready var _spinbox: SpinBox = $SpinBox
@onready var _field: LineEdit = _spinbox.get_line_edit()


func _ready() -> void:
    compatible_types = [TYPE_INT, TYPE_FLOAT]
    if Engine.is_editor_hint():
        return

    init_value()
    _spinbox.value_changed.connect(_on_spinBox_value_changed)
    _field.mouse_entered.connect(_on_field_mouse_entered)
    _field.focus_entered.connect(_on_field_focus_entered)
    _field.context_menu_enabled = false


func init_value() -> void:
    value = GGSSaveManager.load_setting_value(setting)
    _spinbox.set_value_no_signal(value)
    _field.text = str(value)


func reset_setting() -> void:
    super()
    _spinbox.value = value
    _field.text = str(value)


func _on_spinBox_value_changed(new_value: float) -> void:
    value = new_value
    GGS.audio_activated.play()
    if can_apply_on_changed():
        apply_setting()


func _on_field_mouse_entered() -> void:
    GGS.audio_mouse_entered.play()
    if can_grab_focus_on_mouseover():
        _field.grab_focus()


func _on_field_focus_entered() -> void:
    GGS.audio_focus_entered.play()
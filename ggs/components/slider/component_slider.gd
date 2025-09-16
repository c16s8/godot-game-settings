@tool
@icon("res://ggs/components/slider/slider.svg")
extends GGSComponent

@onready var _slider: HSlider = $Slider


func _ready() -> void:
	compatible_types = [TYPE_INT, TYPE_FLOAT]
	if Engine.is_editor_hint():
		return

	init_value()
	_slider.value_changed.connect(_on_slider_value_changed)
	_slider.mouse_entered.connect(_on_slider_mouse_entered)
	_slider.focus_entered.connect(_on_slider_focus_entered)


func init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_slider.set_value_no_signal(value)


func reset_setting() -> void:
	super()
	_slider.value = value


func _on_slider_value_changed(new_value: float) -> void:
	value = new_value
	if can_apply_on_changed():
		apply_setting()


func _on_slider_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		_slider.grab_focus()


func _on_slider_focus_entered() -> void:
	GGS.audio_focus_entered.play()

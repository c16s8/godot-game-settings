@tool
@icon("res://ggs/components/arrow_list/arrow_list.svg")
extends GGSComponent

signal option_selected(option_index: int)

## Options of the list. Note that the option index or id is saved, not its string label.
@export var options: PackedStringArray
## If enabled, the selection will wrap around when reaching the end of options from either side.
@export var wrap_selection: bool = true

@onready var _left_btn: Button = $HBox/LeftBtn
@onready var _option_label: Label = $HBox/OptionLabel
@onready var _right_btn: Button = $HBox/RightBtn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return

	_init_value()
	option_selected.connect(_on_option_selected)
	_left_btn.pressed.connect(_on_left_btn_pressed)
	_right_btn.pressed.connect(_on_right_btn_pressed)
	_left_btn.mouse_entered.connect(_on_any_btn_mouse_entered.bind(_left_btn))
	_right_btn.mouse_entered.connect(_on_any_btn_mouse_entered.bind(_right_btn))
	_left_btn.focus_entered.connect(_on_any_btn_focus_entered)
	_right_btn.focus_entered.connect(_on_any_btn_focus_entered)


func reset_setting() -> void:
	_select(setting.default)
	apply_setting()


func _init_value() -> void:
	value = GGSSaveManager.load_setting_value(setting)
	_select(value, false)


func _select(new_index: int, emit_selected: bool = true) -> void:
	value = new_index % options.size()
	if emit_selected:
		option_selected.emit(value)

	_option_label.text = options[value]
	if not wrap_selection:
		_left_btn.disabled = (value == 0)
		_right_btn.disabled = (value == options.size() - 1)


func _on_option_selected(_option_index: int) -> void:
	if can_apply_on_changed():
		apply_setting()


func _on_left_btn_pressed() -> void:
	_select(value - 1)
	GGS.audio_activated.play()


func _on_right_btn_pressed() -> void:
	_select(value + 1)
	GGS.audio_activated.play()


func _on_any_btn_mouse_entered(Btn: Button) -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		Btn.grab_focus()


func _on_any_btn_focus_entered() -> void:
	GGS.audio_focus_entered.play()

@tool
@icon("res://ggs/components/arrow_list/arrow_list.svg")
extends GGSComponent

signal option_selected(option_index: int)

## Options of the list. Note that the option index or id is saved, not its string label.
@export var options: PackedStringArray
## If enabled, the selection will wrap around when reaching the end of options from either side.
@export var wrap_selection: bool = true

@onready var _LeftBtn: Button = $HBox/LeftBtn
@onready var _OptionLabel: Label = $HBox/OptionLabel
@onready var _RightBtn: Button = $HBox/RightBtn


func _ready() -> void:
	compatible_types = [TYPE_BOOL, TYPE_INT]
	if Engine.is_editor_hint():
		return

	_init_value()
	option_selected.connect(_on_option_selected)
	_LeftBtn.pressed.connect(_on_LeftBtn_pressed)
	_RightBtn.pressed.connect(_on_RightBtn_pressed)

	_LeftBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(_LeftBtn))
	_RightBtn.mouse_entered.connect(_on_AnyBtn_mouse_entered.bind(_RightBtn))
	_LeftBtn.focus_entered.connect(_on_AnyBtn_focus_entered)
	_RightBtn.focus_entered.connect(_on_AnyBtn_focus_entered)


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

	_OptionLabel.text = options[value]
	if not wrap_selection:
		_LeftBtn.disabled = (value == 0)
		_RightBtn.disabled = (value == options.size() - 1)


func _on_option_selected(_option_index: int) -> void:
	if can_apply_on_changed():
		apply_setting()


func _on_LeftBtn_pressed() -> void:
	_select(value - 1)
	GGS.audio_activated.play()


func _on_RightBtn_pressed() -> void:
	_select(value + 1)
	GGS.audio_activated.play()


func _on_AnyBtn_mouse_entered(Btn: Button) -> void:
	GGS.audio_mouse_entered.play()
	if can_grab_focus_on_mouseover():
		Btn.grab_focus()


func _on_AnyBtn_focus_entered() -> void:
	GGS.audio_focus_entered.play()

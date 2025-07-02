@tool
@icon("res://ggs/components/radio_list/radio_list.svg")
extends GGSComponent

enum Lists {HLIST, VLIST}

## The children of the active list will be used as the list items.
@export var list_type: Lists = Lists.HLIST

var _active_list: BoxContainer

@onready var _hlist: HBoxContainer = $HList
@onready var _vlist: VBoxContainer = $VList
@onready var _btn_group: ButtonGroup = ButtonGroup.new()


func _ready() -> void:
    compatible_types = [TYPE_BOOL, TYPE_INT]
    if Engine.is_editor_hint():
        return

    @warning_ignore("incompatible_ternary")
    _active_list = _hlist if list_type == Lists.HLIST else _vlist
    
    init_value()
    _btn_group.pressed.connect(_on_btn_group_pressed)
    for child: Button in _active_list.get_children():
        child.button_group = _btn_group
        child.mouse_entered.connect(_on_any_btn_mouse_entered.bind(child))
        child.focus_entered.connect(_on_any_btn_focus_entered)


func init_value() -> void:
    value = GGSSaveManager.load_setting_value(setting)
    _set_button_pressed(value, true)


func reset_setting() -> void:
    super()
    _set_button_pressed(value, true)


func _set_button_pressed(btn_index: int, pressed: bool) -> void:
    _active_list.get_child(btn_index).set_pressed_no_signal(pressed)


func _get_child_index(target_child: BaseButton) -> int:
    var i: int = 0
    for child: Button in _active_list.get_children():
        if child == target_child:
            return i
        i += 1
    return -1


func _on_btn_group_pressed(button: BaseButton) -> void:
    GGS.audio_activated.play()
    value = _get_child_index(button)
    if can_apply_on_changed():
        apply_setting()


func _on_any_btn_mouse_entered(Btn: Button) -> void:
    GGS.audio_mouse_entered.play()
    if can_grab_focus_on_mouseover():
        Btn.grab_focus()


func _on_any_btn_focus_entered() -> void:
    GGS.audio_focus_entered.play()

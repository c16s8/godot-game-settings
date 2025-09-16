@tool
@icon("res://ggs/components/option_list/option_list.svg")
extends GGSComponent

@onready var _btn: OptionButton = $Btn


func _ready() -> void:
    compatible_types = [TYPE_BOOL, TYPE_INT]
    if Engine.is_editor_hint():
        return

    init_value()
    _btn.item_selected.connect(_on_btn_item_selected)
    _btn.pressed.connect(_on_btn_pressed)
    _btn.mouse_entered.connect(_on_btn_mouse_entered)
    _btn.focus_entered.connect(_on_btn_focus_entered)
    _btn.item_focused.connect(_on_btn_item_focused)


func init_value() -> void:
    value = GGSSaveManager.load_setting_value(setting)
    _btn.select(value)


func reset_setting() -> void:
    super()
    _btn.select(value)


func _on_btn_item_selected(item_index: int) -> void:
    GGS.audio_activated.play()
    value = item_index
    if can_apply_on_changed():
        apply_setting()


func _on_btn_pressed() -> void:
    GGS.audio_focus_entered.play()


func _on_btn_mouse_entered() -> void:
    GGS.audio_mouse_entered.play()

    if can_grab_focus_on_mouseover():
        _btn.grab_focus()


func _on_btn_focus_entered() -> void:
    GGS.audio_focus_entered.play()


func _on_btn_item_focused(_index: int) -> void:
    GGS.audio_focus_entered.play()

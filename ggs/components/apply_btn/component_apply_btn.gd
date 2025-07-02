@icon("res://ggs/components/apply_btn/apply_btn.svg")
extends Button

## Node group associated with the button. When pressed, the button calls [method GGSComponent.apply_setting] on
## all nodes in this node group.
@export var group: String

@export_group("Override", "override_")
## If enabled, plugin settings can be overriden for this specific component.
@export_custom(PROPERTY_HINT_GROUP_ENABLE, "feature") var override_plugin_settings: bool = false
@export var override_grab_focus_on_mouse_over: bool = false


func _ready() -> void:
	pressed.connect(_on_pressed)
	mouse_entered.connect(_on_mouse_entered)
	focus_entered.connect(_on_focus_entered)


func _can_grab_focus_on_mouseover() -> bool:
	if override_plugin_settings:
		return override_grab_focus_on_mouse_over
	else:
		return GGS.plugin_settings.components_grab_focus_on_mouse_over


func _on_pressed() -> void:
	get_tree().call_group(group, "apply_setting")
	GGS.audio_activated.play()


func _on_mouse_entered() -> void:
	GGS.audio_mouse_entered.play()
	if _can_grab_focus_on_mouseover():
		grab_focus()


func _on_focus_entered() -> void:
	GGS.audio_focus_entered.play()

@tool
extends Node
## The core GGS singleton. Handles everything that needs a persistent and global instance to function.

## Emitted when any setting is applied.
signal setting_applied(setting: GGSSetting, value: Variant)

## Audio players used to play the sound effect of the user interface components.
@export var audio_players: Dictionary[String, AudioStreamPlayer] = {
	"mouse_entered": null,
	"mouse_exited": null,
	"focus_entered": null,
	"focus_exited": null,
	"activation_suceeded": null,
	"activation_failed": null,
}

func _ready() -> void:
	GGSSaveManager.clean_up_file()
	if not Engine.is_editor_hint():
		_apply_all()


func _apply_all() -> void:
	for setting: GGSSetting in GGSSaveManager.get_all_settings():
		var value: Variant = GGSSaveManager.load_setting_value(setting)
		setting.apply(value)

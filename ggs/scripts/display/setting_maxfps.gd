@tool
extends GGSSetting
class_name SettingMaxFPS
## Sets the max FPS of the game.

func _init() -> void:
	type = TYPE_INT
	default = 60
	section = "display"


func apply(value: int) -> void:
	Engine.max_fps = value

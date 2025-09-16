@tool
extends GGSSetting
class_name SettingAudioMute
## Sets the mute state of an audio bus.

## Target audio bus.
var audio_bus: String = "Master"


func _init() -> void:
	type = TYPE_BOOL
	default = false
	section = "audio"


func _get_property_list() -> Array:
	return [
		{
			"name": "audio_bus",
			"type": TYPE_STRING,
			"hint": PROPERTY_HINT_ENUM,
			"hint_string": ",".join(_get_audio_bus_list()),
		}
	]


func apply(value: bool) -> void:
	var bus_idx: int = AudioServer.get_bus_index(audio_bus)
	AudioServer.set_bus_mute(bus_idx, value)


func _get_audio_bus_list() -> PackedStringArray:
	var buses: PackedStringArray
	for bus_idx: int in range(AudioServer.bus_count):
		var bus: String = AudioServer.get_bus_name(bus_idx)
		buses.append(bus)
	return buses

@tool
extends Resource
class_name GGSInputGlyphDB
## Resource class for storing and managing image data for mouse and joypad events.

@export var mouse: Dictionary[MouseButton, Texture2D]

@export_group("Xbox")
@export var xbox_button: Dictionary[JoyButton, Texture2D]
@export var xbox_axis: Dictionary[GGSInputUtils.AxisDirection, Texture2D]

@export_group("Playstation")
@export var playstation_button: Dictionary[JoyButton, Texture2D]
@export var playstation_axis: Dictionary[GGSInputUtils.AxisDirection, Texture2D]

@export_group("Switch")
@export var switch_button: Dictionary[JoyButton, Texture2D]
@export var switch_axis: Dictionary[GGSInputUtils.AxisDirection, Texture2D]

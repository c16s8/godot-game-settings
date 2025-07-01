@tool
extends Resource
class_name GGSInputTextDB
## Resource class for storing text data for mouse and joypad input events.

@export var mouse: Dictionary[MouseButton, String] = {
    MOUSE_BUTTON_LEFT: "LMB",
    MOUSE_BUTTON_RIGHT: "RMB",
    MOUSE_BUTTON_MIDDLE: "MMB",
    MOUSE_BUTTON_WHEEL_UP: "MW Up",
    MOUSE_BUTTON_WHEEL_DOWN: "MW Down",
    MOUSE_BUTTON_WHEEL_LEFT: "MW Left",
    MOUSE_BUTTON_WHEEL_RIGHT: "MW Right",
    MOUSE_BUTTON_XBUTTON1: "MB1",
    MOUSE_BUTTON_XBUTTON2: "MB2",
}

@export_group("Xbox")
@export var xbox_button: Dictionary[JoyButton, String] = {
    JOY_BUTTON_A: "A",
    JOY_BUTTON_B: "B",
    JOY_BUTTON_X: "X",
    JOY_BUTTON_Y: "Y",
    JOY_BUTTON_BACK: "Back",
    JOY_BUTTON_GUIDE: "Home",
    JOY_BUTTON_START: "Start",
    JOY_BUTTON_LEFT_STICK: "LS",
    JOY_BUTTON_RIGHT_STICK: "RS",
    JOY_BUTTON_LEFT_SHOULDER: "LB",
    JOY_BUTTON_RIGHT_SHOULDER: "RB",
    JOY_BUTTON_DPAD_UP: "D-Pad Up",
    JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
    JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
    JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
    JOY_BUTTON_MISC1: "Share",
    JOY_BUTTON_PADDLE1: "PAD1",
    JOY_BUTTON_PADDLE2: "PAD2",
    JOY_BUTTON_PADDLE3: "PAD3",
    JOY_BUTTON_PADDLE4: "PAD4",
    JOY_BUTTON_TOUCHPAD: "Touchpad",
}
@export var xbox_axis: Dictionary[GGSInputUtils.AxisDirection, String] = {
    GGSInputUtils.AxisDirection.LEFT_STICK_LEFT: "LStick Left",
    GGSInputUtils.AxisDirection.LEFT_STICK_RIGHT: "LStick Right",
    GGSInputUtils.AxisDirection.LEFT_STICK_UP: "LStick Up",
    GGSInputUtils.AxisDirection.LEFT_STICK_DOWN: "LStick Down",
    GGSInputUtils.AxisDirection.RIGHT_STICK_LEFT: "RStick Left",
    GGSInputUtils.AxisDirection.RIGHT_STICK_RIGHT: "RStick Right",
    GGSInputUtils.AxisDirection.RIGHT_STICK_UP: "RStick Up",
    GGSInputUtils.AxisDirection.RIGHT_STICK_DOWN: "RStick Down",
    GGSInputUtils.AxisDirection.LEFT_TRIGGER: "LT",
    GGSInputUtils.AxisDirection.RIGHT_TRIGGER: "RT",
}

@export_group("Playstation")
@export var playstation_button: Dictionary[JoyButton, String] = {
	JOY_BUTTON_A: "Cross",
	JOY_BUTTON_B: "Circle",
	JOY_BUTTON_X: "Square",
	JOY_BUTTON_Y: "Triangle",
	JOY_BUTTON_BACK: "Select",
	JOY_BUTTON_GUIDE: "PS",
	JOY_BUTTON_START: "Start",
	JOY_BUTTON_LEFT_STICK: "L3",
	JOY_BUTTON_RIGHT_STICK: "R3",
	JOY_BUTTON_LEFT_SHOULDER: "L1",
	JOY_BUTTON_RIGHT_SHOULDER: "R1",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "Microphone",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}
@export var playstation_axis: Dictionary[GGSInputUtils.AxisDirection, String] = {
	GGSInputUtils.AxisDirection.LEFT_STICK_LEFT: "LStick Left",
	GGSInputUtils.AxisDirection.LEFT_STICK_RIGHT: "LStick Right",
	GGSInputUtils.AxisDirection.LEFT_STICK_UP: "LStick Up",
	GGSInputUtils.AxisDirection.LEFT_STICK_DOWN: "LStick Down",
	GGSInputUtils.AxisDirection.RIGHT_STICK_LEFT: "RStick Left",
	GGSInputUtils.AxisDirection.RIGHT_STICK_RIGHT: "RStick Right",
	GGSInputUtils.AxisDirection.RIGHT_STICK_UP: "RStick Up",
	GGSInputUtils.AxisDirection.RIGHT_STICK_DOWN: "RStick Down",
	GGSInputUtils.AxisDirection.LEFT_TRIGGER: "L2",
	GGSInputUtils.AxisDirection.RIGHT_TRIGGER: "R2",
}

@export_group("Switch")
@export var switch_button: Dictionary[JoyButton, String] = {
	JOY_BUTTON_A: "B",
	JOY_BUTTON_B: "A",
	JOY_BUTTON_X: "Y",
	JOY_BUTTON_Y: "X",
	JOY_BUTTON_BACK: "Minus",
	JOY_BUTTON_GUIDE: "Home",
	JOY_BUTTON_START: "Plus",
	JOY_BUTTON_LEFT_STICK: "LS",
	JOY_BUTTON_RIGHT_STICK: "RS",
	JOY_BUTTON_LEFT_SHOULDER: "L",
	JOY_BUTTON_RIGHT_SHOULDER: "R",
	JOY_BUTTON_DPAD_UP: "D-Pad Up",
	JOY_BUTTON_DPAD_DOWN: "D-Pad Down",
	JOY_BUTTON_DPAD_LEFT: "D-Pad Left",
	JOY_BUTTON_DPAD_RIGHT: "D-Pad Right",
	JOY_BUTTON_MISC1: "Capture",
	JOY_BUTTON_PADDLE1: "PAD1",
	JOY_BUTTON_PADDLE2: "PAD2",
	JOY_BUTTON_PADDLE3: "PAD3",
	JOY_BUTTON_PADDLE4: "PAD4",
	JOY_BUTTON_TOUCHPAD: "Touchpad",
}
@export var switch_axis: Dictionary[GGSInputUtils.AxisDirection, String] = {
	GGSInputUtils.AxisDirection.LEFT_STICK_LEFT: "LStick Left",
	GGSInputUtils.AxisDirection.LEFT_STICK_RIGHT: "LStick Right",
	GGSInputUtils.AxisDirection.LEFT_STICK_UP: "LStick Up",
	GGSInputUtils.AxisDirection.LEFT_STICK_DOWN: "LStick Down",
	GGSInputUtils.AxisDirection.RIGHT_STICK_LEFT: "RStick Left",
	GGSInputUtils.AxisDirection.RIGHT_STICK_RIGHT: "RStick Right",
	GGSInputUtils.AxisDirection.RIGHT_STICK_UP: "RStick Up",
	GGSInputUtils.AxisDirection.RIGHT_STICK_DOWN: "RStick Down",
	GGSInputUtils.AxisDirection.LEFT_TRIGGER: "ZL",
	GGSInputUtils.AxisDirection.RIGHT_TRIGGER: "ZR",
}

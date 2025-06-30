@tool
extends RefCounted
class_name GGSUtils
## Provides various utility methods via its subclasses.

## Provides engine types utilities.
class Type:
	static var _names: Dictionary[Variant.Type, String] = {
		TYPE_BOOL: "bool",
		TYPE_INT: "int",
		TYPE_FLOAT: "float",
		TYPE_STRING: "String",
		TYPE_VECTOR2: "Vector2",
		TYPE_VECTOR2I: "Vector2i",
		TYPE_RECT2: "Rect2",
		TYPE_RECT2I: "Rect2i",
		TYPE_VECTOR3: "Vector3",
		TYPE_VECTOR3I: "Vector3i",
		TYPE_TRANSFORM2D: "Transform2D",
		TYPE_VECTOR4: "Vector4",
		TYPE_VECTOR4I: "Vector4i",
		TYPE_PLANE: "Plane",
		TYPE_QUATERNION: "Quaternion",
		TYPE_AABB: "AABB",
		TYPE_BASIS: "Basis",
		TYPE_TRANSFORM3D: "Transform3D",
		TYPE_PROJECTION: "Projection",
		TYPE_COLOR: "Color",
		TYPE_STRING_NAME: "StringName",
		TYPE_NODE_PATH: "NodePath",
		TYPE_RID: "RID",
		TYPE_OBJECT: "Object",
		TYPE_CALLABLE: "Callable",
		TYPE_SIGNAL: "Signal",
		TYPE_DICTIONARY: "Dictionary",
		TYPE_ARRAY: "Array",
		TYPE_PACKED_BYTE_ARRAY: "PackedByteArray",
		TYPE_PACKED_INT32_ARRAY: "PackedInt32Array",
		TYPE_PACKED_INT64_ARRAY: "PackedInt64Array",
		TYPE_PACKED_FLOAT32_ARRAY: "PackedFloat32Array",
		TYPE_PACKED_FLOAT64_ARRAY: "PackedFloat64Array",
		TYPE_PACKED_STRING_ARRAY: "PackedStringArray",
		TYPE_PACKED_VECTOR2_ARRAY: "PackedVector2Array",
		TYPE_PACKED_VECTOR3_ARRAY: "PackedVector3Array",
		TYPE_PACKED_VECTOR4_ARRAY: "PackedVector4Array",
		TYPE_PACKED_COLOR_ARRAY: "PackedColorArray",
	}

	static var _default_values: Dictionary[Variant.Type, Variant] = {
		TYPE_BOOL: false,
		TYPE_INT: 0,
		TYPE_FLOAT: 0.0,
		TYPE_STRING: "",
		TYPE_VECTOR2: Vector2(),
		TYPE_VECTOR2I: Vector2i(),
		TYPE_RECT2: Rect2(),
		TYPE_RECT2I: Rect2i(),
		TYPE_VECTOR3: Vector3(),
		TYPE_VECTOR3I: Vector3i(),
		TYPE_TRANSFORM2D: Transform2D(),
		TYPE_VECTOR4: Vector4(),
		TYPE_VECTOR4I: Vector4i(),
		TYPE_PLANE: Plane(),
		TYPE_QUATERNION: Quaternion(),
		TYPE_AABB: AABB(),
		TYPE_BASIS: Basis(),
		TYPE_TRANSFORM3D: Transform3D(),
		TYPE_PROJECTION: Projection(),
		TYPE_COLOR: Color(),
		TYPE_STRING_NAME: StringName(),
		TYPE_NODE_PATH: NodePath(),
		TYPE_RID: RID(),
		TYPE_OBJECT: null,
		TYPE_CALLABLE: Callable(),
		TYPE_SIGNAL: Signal(),
		TYPE_DICTIONARY: Dictionary(),
		TYPE_ARRAY: Array(),
		TYPE_PACKED_BYTE_ARRAY: PackedByteArray(),
		TYPE_PACKED_INT32_ARRAY: PackedInt32Array(),
		TYPE_PACKED_INT64_ARRAY: PackedInt64Array(),
		TYPE_PACKED_FLOAT32_ARRAY: PackedFloat32Array(),
		TYPE_PACKED_FLOAT64_ARRAY: PackedFloat64Array(),
		TYPE_PACKED_STRING_ARRAY: PackedStringArray(),
		TYPE_PACKED_VECTOR2_ARRAY: PackedVector2Array(),
		TYPE_PACKED_VECTOR3_ARRAY: PackedVector3Array(),
		TYPE_PACKED_VECTOR4_ARRAY: PackedColorArray(),
		TYPE_PACKED_COLOR_ARRAY: PackedVector4Array(),
	}

	static var _associated_hints: Dictionary[Variant.Type, Array] = {
		TYPE_FLOAT: [
			PROPERTY_HINT_RANGE,
			PROPERTY_HINT_EXP_EASING,
		],
		TYPE_INT: [
			PROPERTY_HINT_RANGE,
			PROPERTY_HINT_ENUM,
			PROPERTY_HINT_FLAGS,
			PROPERTY_HINT_LAYERS_2D_RENDER,
			PROPERTY_HINT_LAYERS_2D_PHYSICS,
			PROPERTY_HINT_LAYERS_2D_NAVIGATION,
			PROPERTY_HINT_LAYERS_3D_RENDER,
			PROPERTY_HINT_LAYERS_3D_PHYSICS,
			PROPERTY_HINT_LAYERS_3D_NAVIGATION,
			PROPERTY_HINT_LAYERS_AVOIDANCE,
			PROPERTY_HINT_OBJECT_ID,
			PROPERTY_HINT_INT_IS_POINTER,
		],
		TYPE_STRING: [
			PROPERTY_HINT_ENUM,
			PROPERTY_HINT_ENUM_SUGGESTION,
			PROPERTY_HINT_FILE,
			PROPERTY_HINT_DIR,
			PROPERTY_HINT_GLOBAL_FILE,
			PROPERTY_HINT_GLOBAL_DIR,
			PROPERTY_HINT_MULTILINE_TEXT,
			PROPERTY_HINT_EXPRESSION,
			PROPERTY_HINT_PLACEHOLDER_TEXT,
			PROPERTY_HINT_TYPE_STRING,
			PROPERTY_HINT_NODE_PATH_VALID_TYPES,
			PROPERTY_HINT_SAVE_FILE,
			PROPERTY_HINT_GLOBAL_SAVE_FILE,
			PROPERTY_HINT_LOCALE_ID,
			PROPERTY_HINT_PASSWORD,
			PROPERTY_HINT_INPUT_NAME,
			PROPERTY_HINT_FILE_PATH,
		],
		TYPE_VECTOR2: [
			PROPERTY_HINT_LINK,
		],
		TYPE_VECTOR2I: [
			PROPERTY_HINT_LINK,
		],
		TYPE_VECTOR3: [
			PROPERTY_HINT_LINK,
		],
		TYPE_VECTOR3I: [
			PROPERTY_HINT_LINK,
		],
		TYPE_VECTOR4: [
			PROPERTY_HINT_LINK,
		],
		TYPE_VECTOR4I: [
			PROPERTY_HINT_LINK,
		],
		TYPE_OBJECT: [
			PROPERTY_HINT_RESOURCE_TYPE,
			PROPERTY_HINT_OBJECT_TOO_BIG,
			PROPERTY_HINT_NODE_TYPE,
		],
		TYPE_COLOR: [
			PROPERTY_HINT_COLOR_NO_ALPHA,
		],
		TYPE_ARRAY: [
			PROPERTY_HINT_TYPE_STRING,
			PROPERTY_HINT_ARRAY_TYPE,
		],
		TYPE_DICTIONARY: [
			PROPERTY_HINT_TYPE_STRING,
			PROPERTY_HINT_DICTIONARY_TYPE,
			PROPERTY_HINT_LOCALIZABLE_STRING,
		],
		TYPE_QUATERNION: [
			PROPERTY_HINT_HIDE_QUATERNION_EDIT,
		],
		TYPE_CALLABLE: [
			PROPERTY_HINT_TOOL_BUTTON,
		],
		TYPE_BOOL: [
			PROPERTY_HINT_GROUP_ENABLE,
		],
		TYPE_STRING_NAME: [
			PROPERTY_HINT_INPUT_NAME,
		],
	}


	## Returns the string representation of the given type.
	static func get_name(type: Variant.Type) -> String:
		return _names[type]


	## Returns the editor icon associated with a given type.
	static func get_icon(type: Variant.Type) -> Texture2D:
		if not Engine.is_editor_hint():
			return null

		var editor_interface: EditorInterface = Engine.get_singleton("EditorInterface") as EditorInterface
		var base_control: Control = editor_interface.get_base_control()
		return base_control.get_theme_icon(get_name(type), "EditorIcons")


	## Returns the default value of the given type.
	static func get_default_value(type: Variant.Type) -> Variant:
		return _default_values[type]


	## Returns property hints associated with the given type.
	static func get_associated_hints(type: Variant.Type) -> PackedInt32Array:
		var hints: PackedInt32Array = [PROPERTY_HINT_NONE, PROPERTY_HINT_ONESHOT]
		hints.append_array(_associated_hints[type])
		return hints
	

	## Returns the name of property hints associated with the given type.
	static func get_associated_hints_names(type: Variant.Type) -> PackedStringArray:
		var hints: PackedInt32Array = get_associated_hints(type)
		var hint_names: PackedStringArray
		for hint in hints:
			hint_names.append(Hint.get_name(hint))
		return hint_names


## Provides engine property hint utilities.
class Hint:
	static var _names: Dictionary[PropertyHint, String] = {
		PROPERTY_HINT_NONE: "None",
		PROPERTY_HINT_RANGE: "Range",
		PROPERTY_HINT_ENUM: "Enum",
		PROPERTY_HINT_ENUM_SUGGESTION: "Enum Suggestion",
		PROPERTY_HINT_EXP_EASING: "Exp Easing",
		PROPERTY_HINT_LINK: "Link",
		PROPERTY_HINT_FLAGS: "Flags",
		PROPERTY_HINT_LAYERS_2D_RENDER: "Layers 2D Render",
		PROPERTY_HINT_LAYERS_2D_PHYSICS: "Layers 2D Physics",
		PROPERTY_HINT_LAYERS_2D_NAVIGATION: "Layers 2D Navigation",
		PROPERTY_HINT_LAYERS_3D_RENDER: "Layers 3D Render",
		PROPERTY_HINT_LAYERS_3D_PHYSICS: "Layers 3D Physics",
		PROPERTY_HINT_LAYERS_3D_NAVIGATION: "Layers 3D Navigation",
		PROPERTY_HINT_LAYERS_AVOIDANCE: "Layers Avoidance",
		PROPERTY_HINT_FILE: "File",
		PROPERTY_HINT_DIR: "Dir",
		PROPERTY_HINT_GLOBAL_FILE: "Global File",
		PROPERTY_HINT_GLOBAL_DIR: "Global Dir",
		PROPERTY_HINT_RESOURCE_TYPE: "Resource Type",
		PROPERTY_HINT_MULTILINE_TEXT: "Multiline Text",
		PROPERTY_HINT_EXPRESSION: "Expression",
		PROPERTY_HINT_PLACEHOLDER_TEXT: "Placeholder Text",
		PROPERTY_HINT_COLOR_NO_ALPHA: "Color No Alpha",
		PROPERTY_HINT_OBJECT_ID: "Object ID",
		PROPERTY_HINT_TYPE_STRING: "Type String",
		PROPERTY_HINT_OBJECT_TOO_BIG: "Object too Big",
		PROPERTY_HINT_NODE_PATH_VALID_TYPES: "NodePath Valid Types",
		PROPERTY_HINT_SAVE_FILE: "Save File",
		PROPERTY_HINT_GLOBAL_SAVE_FILE: "Global Save File",
		PROPERTY_HINT_INT_IS_POINTER: "Int is Pointer",
		PROPERTY_HINT_ARRAY_TYPE: "Array Type",
		PROPERTY_HINT_DICTIONARY_TYPE: "Dictionary Type",
		PROPERTY_HINT_LOCALE_ID: "Locale ID",
		PROPERTY_HINT_LOCALIZABLE_STRING: "Localizable String",
		PROPERTY_HINT_NODE_TYPE: "Node Type",
		PROPERTY_HINT_HIDE_QUATERNION_EDIT: "Hide Quaternion Edit",
		PROPERTY_HINT_PASSWORD: "Password",
		PROPERTY_HINT_TOOL_BUTTON: "Tool Button",
		PROPERTY_HINT_ONESHOT: "One Shot",
		PROPERTY_HINT_GROUP_ENABLE: "Group Enable",
		PROPERTY_HINT_INPUT_NAME: "Input Name",
		PROPERTY_HINT_FILE_PATH: "File Path",
	}

	## Returns the string representation of the given property hint.
	static func get_name(hint: PropertyHint) -> String:
		return _names[hint]


## Provides game window utilities.
class GameWindow:
	## Centers game window on the current screen.
	static func center() -> void:
		var screen_id: int = DisplayServer.window_get_current_screen()
		var screen_position: Vector2i = DisplayServer.screen_get_position(screen_id)
		var screen_center: Vector2i = DisplayServer.screen_get_usable_rect(screen_id).size / 2
		var window_center: Vector2i = DisplayServer.window_get_size() / 2
		var target_position: Vector2 = screen_position + screen_center - window_center
		DisplayServer.window_set_position(target_position)


	## Clamps the game window to the current screen size.
	static func clamp_to_screen() -> void:
		var screen_id: int = DisplayServer.window_get_current_screen()
		var screen_size: Vector2i = DisplayServer.screen_get_usable_rect(screen_id).size
		var window_size: Vector2i = DisplayServer.window_get_size()
		var window_width: int = mini(screen_size.x, window_size.x)
		var window_height: int = mini(screen_size.y, window_size.y)
		DisplayServer.window_set_size(Vector2i(window_width, window_height))

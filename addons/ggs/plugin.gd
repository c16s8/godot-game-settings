@tool
extends EditorPlugin

const _MANAGER_NAME: String = "GGSManager"
const _MANAGER_UID: String = "uid://esw7j7or7gpd"

var _inspector_plugin: EditorInspectorPlugin = ggsInspectorPlugin.new()


func _enter_tree() -> void:
	_add_singleton()
	add_inspector_plugin(_inspector_plugin)


func _exit_tree() -> void:
	remove_inspector_plugin(_inspector_plugin)


func _add_singleton() -> void:
	if ProjectSettings.has_setting("autoload/" + _MANAGER_NAME):
		return
	
	var manager_id: int = ResourceUID.text_to_id(_MANAGER_UID)
	var manager_path: String = ResourceUID.get_id_path(manager_id)
	add_autoload_singleton(_MANAGER_NAME, manager_path)

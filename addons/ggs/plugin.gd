@tool
extends EditorPlugin

const _MANAGER_NAME: String = "GGS"
const _MANAGER_UID: String = "uid://esw7j7or7gpd"


func _enter_tree() -> void:
	if ProjectSettings.has_setting("autoload/" + _MANAGER_NAME):
		return
	
	var manager_id: int = ResourceUID.text_to_id(_MANAGER_UID)
	var manager_path: String = ResourceUID.get_id_path(manager_id)
	add_autoload_singleton(_MANAGER_NAME, manager_path)
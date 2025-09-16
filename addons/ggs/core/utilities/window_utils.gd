@tool
extends RefCounted
class_name GGSWindowUtils
## Provides simple game window utilities.

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

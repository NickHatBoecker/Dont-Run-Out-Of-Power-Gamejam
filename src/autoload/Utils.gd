extends Node


const PIXEL_SCALE: int = 7
const DEFAULT_SPEED = 0.8
const MENU_SPEED = 0.5


#region Scene Switch / Fade in/out

## Just a simple fade out, fade in scene switch
## - You can provide "back" as `newScene` to get to previous scene.
## - You can provide "ignore" as `newScene` to show transition, but don't change scene. Nice for animations.
## - You can provide "restart" as `newScene` to restart scene.
## - You can provide "exit" as `newScene` to exit game.
func do_default_scene_switch(newScene: String, speed: float = MENU_SPEED) -> void:
    SceneManager.validate_scene(newScene)
    SceneManager.change_scene(
        newScene,
        _get_default_fade_out(speed),
        _get_default_fade_in(speed),
        _get_default_options()
    )


func do_default_fade_out(speed: float = DEFAULT_SPEED) -> void:
    await SceneManager.pause(_get_default_fade_out(speed), _get_default_options())


func do_menu_fade_out() -> void:
    await SceneManager.pause(_get_default_fade_out(MENU_SPEED), _get_default_options())


func do_default_fade_in(speed: float = DEFAULT_SPEED) -> void:
    await SceneManager.resume(_get_default_fade_in(speed), _get_default_options())


func do_menu_fade_in() -> void:
    await SceneManager.resume(_get_default_fade_in(MENU_SPEED), _get_default_options())


func _get_default_fade_out(speed: float = DEFAULT_SPEED):
    return SceneManager.create_options(speed, "fade", 0.1, false)


func _get_default_fade_in(speed: float = DEFAULT_SPEED):
    return SceneManager.create_options(speed, "fade", 0.1, false)


func _get_default_options():
    return SceneManager.create_general_options("black", 0.0, false, true)

#endregion


## Convert pixel position in SubViewport to normal position.
func pixelPosition2position(pixelPosition: Vector2) -> Vector2:
    return pixelPosition * Vector2(PIXEL_SCALE, PIXEL_SCALE)


## Get current date in format DD.MM.YYYY
func get_current_date_string() -> String:
    return "24.03.2024"


## Convert seconds to string
func seconds_2_string(seconds: int) -> String:
    var minutes = seconds / 60
    var remaining_seconds = seconds % 60

    var minutes_str = str(minutes).pad_zeros(2)
    var seconds_str = str(remaining_seconds).pad_zeros(2)

    return "%s:%s" % [minutes_str, seconds_str]


func get_content_from_json(json: String):
    var json_object = JSON.new()
    json_object.parse(json)

    return await json_object.get_data()

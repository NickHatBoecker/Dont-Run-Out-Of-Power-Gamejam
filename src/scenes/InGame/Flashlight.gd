extends ColorRect

var pixelScale: float = float(Utils.PIXEL_SCALE)
var tileSize: float = 16.00


func _process(_delta: float) -> void:
    var cam = Game.get_player_camera()
    if !cam: return

    _update_position(cam)
    _set_flashlight_point(cam)


func play_death_animation() -> void:
    var oldDis1: float = material.get_shader_parameter("dis1")
    var oldDis2: float = material.get_shader_parameter("dis2")

    var throttle: int = 10
    for i in throttle:
        _set_distance(
            material.get_shader_parameter("dis1") + 0.1 / throttle,
            material.get_shader_parameter("dis2") + 0.2 / throttle,
        )
        await get_tree().create_timer(0.03).timeout

    await get_tree().create_timer(1).timeout
    _set_distance(oldDis1, oldDis2)


func _update_position(cam: Camera2D) -> void:
    var center: Vector2 = cam.get_screen_center_position()
    var viewport: Vector2 = get_viewport_rect().size / 2
    position = center - viewport


func _set_flashlight_point(cam: Camera2D) -> void:
    var camOffset = cam.get_viewport_transform()[2] / pixelScale
    var camPosition = (cam.position * pixelScale) + (camOffset * pixelScale)

    var weirdValue = 8.0 # Why 8.0?
    var sixteenToNineFix = 0.56 # Don't know why but this is for 16/9 screen.

    camPosition = camPosition + (get_viewport_rect().size / 2)
    camPosition = camPosition / get_viewport_rect().size
    camPosition = Vector2(
        camPosition.x / weirdValue,
        camPosition.y / (weirdValue + sixteenToNineFix),
    )

    material.set_shader_parameter("multiplier", sixteenToNineFix)
    material.set_shader_parameter(
        "player_position",
        Vector2(camPosition.x, camPosition.y)
    )


func _set_distance(dis1: float, dis2: float) -> void:
    material.set_shader_parameter("dis1", dis1)
    material.set_shader_parameter("dis2", dis2)

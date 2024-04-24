extends ColorRect

@export var active = true


func _enter_tree() -> void:
    if active:
        z_index = 100


func _ready() -> void:
    if !active: return

    await get_tree().create_timer(2).timeout
    var fadeIn = SceneManager.create_options(1, "fade", 0.1, false)
    var options = SceneManager.create_general_options("black", 0.0, false, true)
    SceneManager.show_first_scene(fadeIn, options)
    z_index = 0

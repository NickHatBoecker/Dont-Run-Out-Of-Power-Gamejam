extends Control


func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        _on_back_pressed()


func _on_back_pressed() -> void:
    AudioManager.play_sound("sfx", "cancel")
    Store.set_scene_switch_data({ "setFocus": "Credits" })
    Utils.do_default_scene_switch("back")

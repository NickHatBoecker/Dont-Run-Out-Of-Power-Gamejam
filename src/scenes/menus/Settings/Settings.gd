extends Control

const WINDOW_TYPE_WINDOWED = 0
const WINDOW_TYPE_FULLSCREEN = 1


var isPauseMenu: bool = false


func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        _on_back_pressed()


func _on_draw() -> void:
    $Content/SfxVolume/Slider.update_by_store()
    $Content/MusicVolume/Slider.update_by_store()
    $Content/SfxVolume/Slider.grab_focus()
    _update_window_setting()


func _on_back_pressed() -> void:
    AudioManager.play_sound("sfx", "cancel")

    if isPauseMenu:
        await Utils.do_menu_fade_out()
        hide()
        await Utils.do_menu_fade_in()
    else:
        Store.set_scene_switch_data({ "setFocus": "Settings" })
        Utils.do_default_scene_switch("back")
        AudioManager.stop_music()


func _on_window_changed(index: int) -> void:
    if index == WINDOW_TYPE_WINDOWED:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
        Settings.set_parameter("window", DisplayServer.WINDOW_MODE_WINDOWED)
    elif index == WINDOW_TYPE_FULLSCREEN:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
        Settings.set_parameter("window", DisplayServer.WINDOW_MODE_FULLSCREEN)


func _update_window_setting() -> void:
    if Settings.vars.window == DisplayServer.WINDOW_MODE_WINDOWED:
        $Content/WindowControl/Window.selected = WINDOW_TYPE_WINDOWED
    elif Settings.vars.window == DisplayServer.WINDOW_MODE_FULLSCREEN:
        $Content/WindowControl/Window.selected = WINDOW_TYPE_FULLSCREEN

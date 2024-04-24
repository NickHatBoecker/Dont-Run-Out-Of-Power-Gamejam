extends PanelContainer


signal restart_level


func _on_draw() -> void:
    $Menus/Settings.hide()
    $Menus/Settings.isPauseMenu = true
    $VBoxContainer/Continue.grab_focus()


func _on_continue_pressed() -> void:
    AudioManager.play_sound("sfx", "cancel")
    hide()
    Store.state.disablePlayerControls = false


func _on_settings_pressed() -> void:
    await Utils.do_menu_fade_out()
    $Menus/Settings.show()
    await Utils.do_menu_fade_in()


func _on_back_to_start_pressed() -> void:
    Store.reset()
    AudioManager.stop_music()
    Utils.do_default_scene_switch("start_menu")


func _on_settings_hidden() -> void:
    $VBoxContainer/Settings.grab_focus()


func _on_restart_level_pressed() -> void:
    emit_signal("restart_level")

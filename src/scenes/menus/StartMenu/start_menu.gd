extends PanelContainer

@export var sceneAfterStart: String = "level_selection"


func _ready() -> void:
    $Wrapper/Buttons/Start.grab_focus()
    _update_focus()


func _on_start_pressed() -> void:
    Utils.do_default_scene_switch(sceneAfterStart)


func _on_exit_pressed() -> void:
    Utils.do_default_scene_switch("exit")


func _on_settings_pressed() -> void:
    Utils.do_default_scene_switch("settings")


func _on_credits_pressed() -> void:
    Utils.do_default_scene_switch("Credits")


func _update_focus() -> void:
    var data = Store.state.sceneSwitchData
    if data and "setFocus" in data:
        if find_child(data.setFocus):
            find_child(data.setFocus).grab_focus()

extends PanelContainer

@onready var LevelButtons = $VBoxContainer/GridContainer

var levelButtonScene: PackedScene = preload("res://src/objects/LevelSelectionButton.tscn")


func _ready() -> void:
    _remove_debug_buttons()
    _update_hint_label()

    if OS.is_debug_build():
        _create_test_level_button()
    _create_level_buttons()
    LevelButtons.get_child(0).grab_focus()


func _input(event: InputEvent) -> void:
    if visible and event.is_action_pressed("ui_cancel"):
        _on_back_pressed()


func _remove_debug_buttons() -> void:
    for i in LevelButtons.get_children():
        LevelButtons.remove_child(i)


func _create_test_level_button() -> void:
    var testButton = levelButtonScene.instantiate()
    testButton.pressed.connect(Callable(self, "_on_level_button_pressed").bind(testButton.sceneName))
    LevelButtons.add_child(testButton)


func _create_level_buttons() -> void:
    for i in Store.NUM_LEVELS:
        var level = i + 1
        var levelButton = levelButtonScene.instantiate()
        levelButton.text = "%d" % level
        levelButton.sceneName = "Level%d" % level

        # Disable level if not reached yet
        if level > 1 and (level - 1) > Store.state.highestFinishedLevel:
            levelButton.disabled = true

        levelButton.pressed.connect(Callable(self, "_on_level_button_pressed").bind(levelButton.sceneName))

        LevelButtons.add_child(levelButton)


func _on_level_button_pressed(level) -> void:
    Store.set_level_to_load(level)
    Utils.do_default_scene_switch("in_game")


func _on_back_pressed() -> void:
    AudioManager.play_sound("sfx", "cancel")
    Utils.do_default_scene_switch("back")


func _update_hint_label() -> void:
    $VBoxContainer/HintLabel.text = $VBoxContainer/HintLabel.text.format({ "numLevels": Store.NUM_LEVELS })

extends Node2D


# @TODO FEATURES: Spikes (reset on touch or will push you to edge?)
# @TODO FEATURE: Batteries to regain power?
# @TODO FEATURE: Add "Number of fallen down" to highscore screen
# @TODO FEATURE: API calls?


@onready var PauseMenu = $PauseMenu
@onready var LevelWrapper = $CurrentScene/SubViewportContainer/SubViewport


var nextLevel = null


func _ready() -> void:
    Game.init_game()
    Store.set_is_game_started(true)
    $UI.show()
    $NightVision.hide()
    $UI/LevelName.text = LevelWrapper.get_child(0).mapName

    var Flashlight = Game.get_flashlight()
    Flashlight.pixelScale = _get_pixel_scale()
    Flashlight.show()
    _init_night_vision_timer()

    LevelWrapper.get_child(0).change_level.connect(Callable(self, "_on_enter_exit"))

    if Store.state.levelToLoad:
        nextLevel = Store.state.levelToLoad
        _change_level()
        Store.set_level_to_load("")

    $UI/Instructions.show()


func _process(_delta: float) -> void:
    if Store.state.nightVisionPower <= 0:
        _set_night_vision(false)


func _input(event: InputEvent) -> void:
    if Store.state.disablePlayerControls: return
    if Store.state.isCutSceneActive: return

    if event.is_action_pressed("ui_pause"):
        _open_pause_menu()
    elif event.is_action_pressed("ui_nightvision"):
        if Store.state.nightVisionPower > 0:
            _set_night_vision(!$NightVision.visible, true)


func _open_pause_menu() -> void:
    $FoundExitTimer.paused = true
    $TimeUsedFlashlightTimer.paused = true
    Store.state.disablePlayerControls = true
    $UI.hide()
    PauseMenu.show()
    $NightVisionTimer.paused = true


func _on_pause_menu_hidden() -> void:
    $UI.show()
    if $NightVision.visible:
        $NightVisionTimer.paused = false
        $TimeUsedFlashlightTimer.paused = false
    $FoundExitTimer.paused = false


func _on_night_vision_timer_timeout() -> void:
    if Store.state.nightVisionPower <= 0: return
    Store.set_night_vision_power(Store.state.nightVisionPower - 3)


func _init_night_vision_timer() -> void:
    # @TODO set timer time by api
    $NightVisionTimer.start()
    $NightVisionTimer.paused = true


func _get_pixel_scale() -> float:
    return LevelWrapper.size.x / LevelWrapper.size_2d_override.x


func _set_night_vision(payload: bool, userInput: bool = false) -> void:
    if userInput:
        AudioManager.play_sound("sfx", "nightVision")
    $NightVision.visible = payload
    $NightVisionTimer.paused = !$NightVision.visible
    $TimeUsedFlashlightTimer.paused = !$NightVision.visible

    Game.get_flashlight().visible = !$NightVision.visible


func _on_enter_exit(levelName: String) -> void:
    nextLevel = levelName
    _set_night_vision(false)
    $FoundExitTimer.stop()
    $UI/YouDidIt.show()


func _change_level() -> void:
    if !nextLevel: return

    var nextLevelScene: PackedScene
    var maxLevel = "Level%d" % (Store.NUM_LEVELS + 1)
    if nextLevel == maxLevel:
        if OS.is_debug_build():
            nextLevelScene = load("res://src/scenes/InGame/Levels/TestLevel/TestLevel.tscn")
        else:
            AudioManager.stop_music()
            Utils.do_default_scene_switch("level_selection")
            return
    elif nextLevel == "TestLevel":
        nextLevelScene = load("res://src/scenes/InGame/Levels/TestLevel/TestLevel.tscn")
    else:
        nextLevelScene = load("res://src/scenes/InGame/Levels/%s.tscn" % nextLevel)
    #print("NEXT LEVEL: ", nextLevel)
    nextLevel = null

    var nextLevelInstance = nextLevelScene.instantiate()
    nextLevelInstance.change_level.connect(Callable(self, "_on_enter_exit"))

    var oldLevel = LevelWrapper.get_child(0)
    LevelWrapper.remove_child(oldLevel)
    oldLevel.queue_free()

    LevelWrapper.add_child(nextLevelInstance)
    Game.init_scene()
    $UI/LevelName.text = nextLevelInstance.mapName


func _on_pause_menu_restart_level() -> void:
    var currentScene = Game.get_current_scene()
    var player = Game.get_player()
    if !currentScene or !player: return

    Store.set_time_used_flashlight(0)
    Store.set_time_to_find_exit(0)
    Store.set_night_vision_power(currentScene.startPower)
    player.position = currentScene.playerOnStart.position
    player.currentDirection = currentScene.playerOnStart.currentDirection
    _set_night_vision(false)

    # @TODO Reset API timer?
    Store.set_time_used_flashlight(0)
    Store.set_time_to_find_exit(0)

    PauseMenu.hide()
    Store.state.disablePlayerControls = false


func _on_continue_to_next_level() -> void:
    $FoundExitTimer.reset()
    $TimeUsedFlashlightTimer.reset()
    $UI/YouDidIt.hide()
    _change_level()
    $FoundExitTimer.start()


func _on_instructions_hidden() -> void:
    $FoundExitTimer.paused = false

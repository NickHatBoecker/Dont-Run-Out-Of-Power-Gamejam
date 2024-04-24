extends Node2D
class_name LevelController


signal change_level


@export var mapName: String
@export var mapPath: String
@export var nextSceneId: String
@export var startPower: int = 100


const TERRAIN_ABYSS = 0
const TERRAIN_EXIT = 1

var playerOnStart: PlayerOnStart


func _ready() -> void:
    Store.set_night_vision_power(startPower)
    playerOnStart = PlayerOnStart.new($Player.position, $Player.currentDirection)
    $Flashlight.show()


func _on_draw() -> void:
    Store.set_map(mapName, mapPath)


func reset_player(animation: String) -> void:
    ## Prevent running this multiple times
    if $Player.disableInput == true: return

    $Player.disableInput = true
    $Player.disableMovement = true

    get_tree().paused = true
    AudioManager.play_sound("sfx", animation)
    $Player.play_death_animation(animation)
    await $Flashlight.play_death_animation()
    get_tree().paused = false

    await $Player.stop_death_animation(animation)
    $Player.force_stop()
    $Player.position = playerOnStart.position
    $Player.initialPosition = playerOnStart.position
    $Player.currentDirection = playerOnStart.currentDirection
    $Player.setIdle()
    await get_tree().create_timer(0.5).timeout
    $Player.disableInput = false
    $Player.disableMovement = false


func _on_player_moved_finished(data) -> void:
    var localToMap = $ground.local_to_map(data) + Vector2i(1, 1)
    var tileData = $ground.get_cell_tile_data(0, localToMap)
    if !tileData: return
    #print("DEBUG:: TERRAIN: ", tileData.terrain)

    if tileData.terrain == TERRAIN_ABYSS:
        _on_stepped_on_abyss()
    elif tileData.terrain == TERRAIN_EXIT:
        _on_stepped_on_exit()


func _on_stepped_on_abyss() -> void:
    reset_player(PlayerController.ANIMATION_FALL)


func _on_stepped_on_exit() -> void:
    $Player.disableInput = true
    $Player.disableMovement = true
    AudioManager.play_sound("sfx", "enterExit")
    await get_tree().create_timer(0.5).timeout
    Store.set_highest_finished_level(int(mapPath.replace("Level", "")))
    _save_level_exit()
    emit_signal("change_level", nextSceneId)


func _save_level_exit() -> void:
    # @TODO Save to API

    var currentLevel = CurrentLevel.new()
    currentLevel.levelPath = mapPath
    currentLevel.timeUsedFlashlight = Store.state.timeUsedFlashlight
    currentLevel.remainingPowerLevel = Store.state.nightVisionPower
    currentLevel.timeToFindExit = Store.state.timeToFindExit
    SaveManager.save_game(currentLevel)

extends Node


const NUM_LEVELS = 6


var DEFAULT_STATE = {
    "isGameStarted": false,
    "highestFinishedLevel": 0,
    "playerPosition": {
        "position": Vector2.ZERO,
        "direction": Vector2.ZERO,
    },
    "disablePlayerControls": false,
    "isCutSceneActive": false,
    "sceneSwitchData": null,
    "map": "",
    "mapPath": "",
    "levelToLoad": "",

    # Per level
    "nightVisionPower": 100,
    "timeUsedFlashlight": 0, # In seconds
    "flashlightHighscore": 0, # In seconds
    "remainingPowerHighscore": 0, # In seconds
    "timeToFindExit": 0, # In seconds
    "exitHighscore": 0, # In seconds
}

var state = DEFAULT_STATE.duplicate(true)


## We have to reset store by hand, because `duplicate` does not work.
func reset() -> void:
    state.isGameStarted = false
    state.disablePlayerControls = false
    state.isCutSceneActive = false
    state.sceneSwitchData = null
    state.map = ""
    state.mapPath = ""
    state.levelToLoad = ""
    state.timeUsedFlashlight = 0
    state.timeToFindExit = 0


func set_player_position(payload: Dictionary) -> void:
    state.playerPosition = payload


func set_disable_player_controls(payload: bool) -> void:
    state.disablePlayerControls = payload


func set_cut_scene_active(payload: bool) -> void:
    state.isCutSceneActive = payload


func set_scene_switch_data(payload: Dictionary) -> void:
    state.sceneSwitchData = payload


func set_map(map: String, mapPath: String) -> void:
    state.map = map
    state.mapPath = mapPath


func set_is_game_started(payload: bool) -> void:
    state.isGameStarted = payload


func set_night_vision_power(payload: int) -> void:
    state.nightVisionPower = payload


func set_highest_finished_level(payload: int) -> void:
    if payload > state.highestFinishedLevel:
        state.highestFinishedLevel = payload


func set_level_to_load(payload: String) -> void:
    state.levelToLoad = payload


func set_time_to_find_exit(payload: int) -> void:
    state.timeToFindExit = payload


func set_time_used_flashlight(payload: int) -> void:
    state.timeUsedFlashlight = payload


func set_flashlight_highscore(payload: int) -> void:
    state.flashlightHighscore = payload


func set_remaining_power_highscore(payload: int) -> void:
    state.remainingPowerHighscore = payload


func set_exit_highscore(payload: int) -> void:
    state.exitHighscore = payload

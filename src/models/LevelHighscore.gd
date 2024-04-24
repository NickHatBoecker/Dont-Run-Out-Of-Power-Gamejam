extends Node
class_name LevelHighscore


var levelPath: String = ""
var flashlightHighscore: int = 0
var remainingPower: int = 100
var exitHighscore: int = 0


func create_by_current_level(currentLevel: CurrentLevel, oldSaveData: LevelHighscore) -> Dictionary:
    if oldSaveData.levelPath == "":
        _set_by_current_level(currentLevel)
        _update_store()
        return inst_to_dict(self)
    else:
        _set_by_level_highscore(oldSaveData)
        _overwrite(currentLevel)
        _update_store()
        return inst_to_dict(self)


func set_by_dict(levelHighscore: Dictionary) -> void:
    levelPath = levelHighscore.levelPath
    flashlightHighscore = levelHighscore.flashlightHighscore
    remainingPower = levelHighscore.remainingPower
    exitHighscore = levelHighscore.exitHighscore


func _set_by_current_level(currentLevel: CurrentLevel) -> void:
    levelPath = currentLevel.levelPath
    flashlightHighscore = currentLevel.timeUsedFlashlight
    remainingPower = currentLevel.remainingPowerLevel
    exitHighscore = currentLevel.timeToFindExit


func _set_by_level_highscore(levelHighscore: LevelHighscore) -> void:
    levelPath = levelHighscore.levelPath
    flashlightHighscore = levelHighscore.flashlightHighscore
    remainingPower = levelHighscore.remainingPower
    exitHighscore = levelHighscore.exitHighscore


func _overwrite(currentLevel: CurrentLevel):
    if currentLevel.timeUsedFlashlight < flashlightHighscore:
        flashlightHighscore = currentLevel.timeUsedFlashlight
    if currentLevel.remainingPowerLevel > remainingPower:
        remainingPower = currentLevel.remainingPowerLevel
    if currentLevel.timeToFindExit < exitHighscore:
        exitHighscore = currentLevel.timeToFindExit


func _update_store() -> void:
    Store.set_flashlight_highscore(flashlightHighscore)
    Store.set_remaining_power_highscore(remainingPower)
    Store.set_exit_highscore(exitHighscore)

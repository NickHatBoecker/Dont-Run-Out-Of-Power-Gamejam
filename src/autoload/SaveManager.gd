extends Node

signal game_saved
signal game_loaded

const SAVE_FILE_NAME = 'user://dont_run_out_of_power_save.json'

var loadedData = null


## Save game. Provide save data here.
func save_game(currentLevel: CurrentLevel) -> void:
    var saveData = {
        "highestFinishedLevel": Store.state.highestFinishedLevel,
        "date": Utils.get_current_date_string(),
        "levels": {},
    }

    for i in Store.NUM_LEVELS:
        var levelId = "Level%d" % (i + 1)

        if levelId == currentLevel.levelPath:
            var levelHighscore = LevelHighscore.new()
            var oldSaveData = LevelHighscore.new()
            if loadedData and loadedData.levels.has(levelId):
                oldSaveData = LevelHighscore.new()
                oldSaveData.set_by_dict(loadedData.levels.get(levelId))
            saveData.levels[levelId] = levelHighscore.create_by_current_level(currentLevel, oldSaveData)
        else:
            if loadedData and loadedData.levels.has(levelId):
                saveData.levels[levelId] = loadedData.levels[levelId]

    #print('SAVE:: ', saveData)
    _save_to_file(saveData)

    if loadedData == null:
        # This is needed for highscore comparison
        load_game()


## Load saved data from file.
func load_game() -> void:
    var data = _get_content_from_file()
    if (data):
        loadedData = data
        Store.set_highest_finished_level(get_parameter("highestFinishedLevel", 0))

    #print('LOAD:: ', loadedData)
    emit_signal('game_loaded')


## Delete data
func delete_data() -> void:
    if FileAccess.file_exists(SAVE_FILE_NAME):
        DirAccess.remove_absolute(SAVE_FILE_NAME)


## Get a key from saved data
func get_parameter(parameter: String, default = null):
    if loadedData and loadedData.has(parameter):
        return loadedData[parameter]
    if default != null: return default

    return null


## Get data without saving it to store.
func get_save_data() -> Dictionary:
    if (_get_content_from_file()):
        return _get_content_from_file()
    return {}


## Check if game has saved data
func is_empty() -> bool:
    return !FileAccess.file_exists(SAVE_FILE_NAME)


## Save retrieved data to file
func _save_to_file(saveData: Dictionary) -> void:
    var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
    file.store_string(JSON.stringify(saveData))
    file.close()

    emit_signal('game_saved')


## Get saved data from file
func _get_content_from_file():
    if !FileAccess.file_exists(SAVE_FILE_NAME): return

    var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)
    var jsonResult = JSON.parse_string(file.get_as_text())
    file.close()
    if !jsonResult: return null

    return jsonResult

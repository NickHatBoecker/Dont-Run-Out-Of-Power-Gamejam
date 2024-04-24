extends Node

signal settings_saved
signal settings_loaded

const SAVE_FILE_NAME = 'user://settings.json'

var vars = {
    "sfxVolume": 4, # Number of the settings control. Not db.
    "musicVolume": 4, # Number of the settings control. Not db.
    "window": DisplayServer.WINDOW_MODE_WINDOWED,
}


func _ready() -> void:
    _load_from_file()
    DisplayServer.window_set_mode(vars.window)


## Get a parameter from saved settings
func get_parameter(key: String, default = null):
    if vars.has(key):
        return vars[key]
    if default != null:
        return default

    return null


## Set parameter and save settings
func set_parameter(key: String, value = null) -> void:
    vars[key] = value
    _save_to_file()


#
# Get all settings
#
func get_all() -> Object:
    return vars


## Save all data to file
func _save_to_file() -> void:
    var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.WRITE)
    file.store_line(JSON.stringify(vars))
    file.close()
    emit_signal('settings_saved')


## Load saved data from file
func _load_from_file() -> void:
    if !FileAccess.file_exists(SAVE_FILE_NAME): return

    var file = FileAccess.open(SAVE_FILE_NAME, FileAccess.READ)

    var jsonResponse = JSON.parse_string(file.get_as_text())
    if !jsonResponse:
        emit_signal('settings_loaded')
        file.close()
        return

    file.close()

    for i in vars.keys():
        if jsonResponse.has(i):
            vars[i] = jsonResponse[i]

    #print('LOAD SETTINGS:: ', vars)
    emit_signal('settings_loaded')

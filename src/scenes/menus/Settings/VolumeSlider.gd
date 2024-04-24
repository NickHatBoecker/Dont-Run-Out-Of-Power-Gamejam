extends Slider

@export var playerId: String = ""
@export var testSound: String = ""


## Called when the node enters the scene tree for the first time.
func _ready() -> void:
    tick_count = 5
    ticks_on_borders = true
    min_value = 0
    max_value = 4

    ## Set volume from settings
    value = AudioManager.get_volume(playerId)

    value_changed.connect(_on_value_changed)


func update_by_store() -> void:
    if is_connected("value_changed", _on_value_changed):
        value_changed.disconnect(_on_value_changed)

    # Set volume from store
    value = AudioManager.get_volume(playerId)

    value_changed.connect(_on_value_changed)


func _on_value_changed(volumeValue: float) -> void:
    AudioManager.set_volume(playerId, int(volumeValue))
    AudioManager.play_sound("sfx", testSound)

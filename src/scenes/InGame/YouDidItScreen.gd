extends Control

signal continueToNextLevel


@onready var HighscoreLabel = $ColorRect/VBoxContainer/HBoxContainer/Label
@onready var Continue = $ColorRect/VBoxContainer/MarginContainer/Continue


var labelOnStart = ""


var lines = [
    { "storeVar": "timeUsedFlashlight", "isTimestamp": true, "compareTo": "" },
    { "storeVar": "flashlightHighscore", "isTimestamp": true, "compareTo": "timeUsedFlashlight" },
    { "storeVar": "nightVisionPower", "isTimestamp": false, "compareTo": "" },
    { "storeVar": "remainingPowerHighscore", "isTimestamp": false, "compareTo": "nightVisionPower" },
    { "storeVar": "timeToFindExit", "isTimestamp": true, "compareTo": "" },
    { "storeVar": "exitHighscore", "isTimestamp": true, "compareTo": "timeToFindExit" },
]


func _ready() -> void:
    labelOnStart = HighscoreLabel.text


func _on_draw() -> void:
    _reset()
    AudioManager.play_sound("sfx", "success")
    await _draw_line_by_line(_get_updated_text())
    $ColorRect/Confetti.show()
    Continue.show()
    Continue.grab_focus()


func _reset() -> void:
    $ColorRect/Confetti.hide()
    HighscoreLabel.text = ""
    Continue.hide()


func _get_updated_text() -> String:
    var data = {}
    for i in lines:
        data[i.storeVar] = _get_value(i.storeVar, i.isTimestamp, i.compareTo)

    return labelOnStart.format(data)


func _get_value(storeVariable: String, isTimestamp: bool, compareTo: String) -> String:
    var value = _get_value_from_store(storeVariable)
    var compareToVal = null
    if compareTo != "":
        compareToVal = _get_value_from_store(compareTo)

    if compareToVal != null and compareToVal == value:
        value = "NEW HIGHSCORE"
    elif isTimestamp:
        value = Utils.seconds_2_string(value)
    else:
        if value < 0: value = 0

    return str(value)


func _get_value_from_store(variableName: String) -> int:
    if Store.state.has(variableName):
        return Store.state.get(variableName)
    return 0


func _draw_line_by_line(text: String) -> void:
    var lines = text.split("\n")
    for i in lines:
        HighscoreLabel.text += "%s\n" % i
        await get_tree().create_timer(0.3).timeout


func _on_continue_pressed() -> void:
    emit_signal("continueToNextLevel")

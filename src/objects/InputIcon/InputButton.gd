@tool
extends HBoxContainer

signal pressed

@export var buttonText: String = "Back"
@export var disabled: bool = false
@export_enum(
    "ui_accept", "ui_cancel", "ui_delete", "ui_nightvision"
) var action: String = "ui_cancel"


var xboxIcons = {
    "ui_accept": load("res://src/objects/InputIcon/images/xbox_a.png"),
    "ui_cancel": load("res://src/objects/InputIcon/images/xbox_b.png"),
    "ui_delete": load("res://src/objects/InputIcon/images/xbox_x.png"),
    "ui_nightvision": load("res://src/objects/InputIcon/images/xbox_x.png"),
}

var keyboardIcons = {
    "ui_accept": load("res://src/objects/InputIcon/images/key_enter.png"),
    "ui_cancel": load("res://src/objects/InputIcon/images/key_esc.png"),
    "ui_delete": load("res://src/objects/InputIcon/images/key_x.png"),
    "ui_nightvision": load("res://src/objects/InputIcon/images/key_x.png"),
}


func _process(_delta: float) -> void:
    $Button.text = buttonText
    $Button.visible = buttonText != ""

    $Icon.disabled = disabled
    $Button.disabled = disabled

    if !"inputType" in InputManager: return

    if InputManager.inputType == "keyboard":
        $Icon.texture_normal = keyboardIcons[action]
    else:
        $Icon.texture_normal = xboxIcons[action]


func _on_button_pressed() -> void:
    emit_signal("pressed")

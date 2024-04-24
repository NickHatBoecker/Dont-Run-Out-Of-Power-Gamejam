extends Node

var inputType = 'keyboard'


func _ready() -> void:
    inputType = InputHelper.guess_device_name()
    InputHelper.device_changed.connect(_on_input_device_changed)


func _on_input_device_changed(device: String, _device_index: int) -> void:
    inputType = device
    print("Changed inputType to ", inputType)

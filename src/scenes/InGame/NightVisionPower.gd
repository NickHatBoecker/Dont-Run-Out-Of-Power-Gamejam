extends Control

var startWidth: float = 0.0


func _ready() -> void:
    startWidth = $Full.size.x


func _process(_delta: float) -> void:
    $Full.size.x = _power2width()


func _power2width() -> float:
    return float(startWidth / 100 * Store.state.nightVisionPower)

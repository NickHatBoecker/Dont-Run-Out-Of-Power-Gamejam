extends Node
class_name PlayerOnStart

var position: Vector2
var currentDirection: Vector2


func _init(_position: Vector2, _currentDirection: Vector2) -> void:
    position = _position
    currentDirection = _currentDirection

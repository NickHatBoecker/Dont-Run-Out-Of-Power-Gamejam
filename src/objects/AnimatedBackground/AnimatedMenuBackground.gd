@tool
extends Node2D

@export var texture: Texture


func _process(_delta) -> void:
    if texture:
        $Animation.texture = texture

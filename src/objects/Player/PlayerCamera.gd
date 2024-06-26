extends Camera2D

@onready var topLeft = $TopLeft
@onready var bottomRight = $BottomRight

func _process(_delta) -> void:
    limit_top = topLeft.position.y
    limit_left = topLeft.position.x
    limit_bottom = bottomRight.position.y
    limit_right = bottomRight.position.x

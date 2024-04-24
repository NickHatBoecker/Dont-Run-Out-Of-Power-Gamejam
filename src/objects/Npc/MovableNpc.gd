extends CharacterBody2D
class_name MovableNpc


signal moved
signal moved_finished


@export var WALK_SPEED: float = 4.0
@export var currentDirection: Vector2 = Vector2.UP
@export var disableMovement: bool = false
@export_multiline var behaviorChainJson: String = ""


var tileSize: int = 16
var walkSpeed : float = WALK_SPEED

var initialPosition: Vector2 = Vector2(0, 0)
var inputDirection: Vector2 = Vector2(0, 1)
var isMoving: bool = false
var percentMovedToNextTile: float = 0.0

var behaviorChain = []
var currentBehaviorChainIndex = 0


func _ready():
    behaviorChain = await Utils.get_content_from_json(behaviorChainJson)
    initialPosition = position
    inputDirection = currentDirection


func _physics_process(delta):
    if disableMovement: return

    if isMoving == false:
        _process_movement()

    if inputDirection != Vector2.ZERO:
        move(delta, inputDirection)
    else:
        isMoving = false

    update_sprite(inputDirection)

    emit_signal("moved", {
        "delta": delta,
        "direction": inputDirection,
        "currentDirection": currentDirection,
        "position": position,
    })


func set_direction(direction: Vector2):
    currentDirection = direction
    update_sprite(currentDirection)


func move(delta, direction: Vector2):
    percentMovedToNextTile += walkSpeed * delta

    if percentMovedToNextTile >= 1.0:
        # End moving
        position = initialPosition + (inputDirection * tileSize)
        initialPosition = position
        percentMovedToNextTile = 0.0
        isMoving = false
        _set_next_behavior_index()
        emit_signal("moved_finished", position)
    else:
        # Continue moving
        position = initialPosition + (inputDirection * tileSize * percentMovedToNextTile)


func update_sprite(newDirection):
    if newDirection == Vector2.ZERO:
        _set_idle()
        return

    $NpcAnimations/AnimationTree.get("parameters/playback").travel("Walk")
    $NpcAnimations/AnimationTree.set("parameters/Idle/blend_position", newDirection)
    $NpcAnimations/AnimationTree.set("parameters/Walk/blend_position", newDirection)


func _set_idle() -> void:
    $NpcAnimations/AnimationTree.get("parameters/playback").travel("Idle")


func _process_movement() -> void:
    walkSpeed = WALK_SPEED

    # Get inputDirection from behaviorChain
    inputDirection = string_2_direction(behaviorChain[currentBehaviorChainIndex])

    var newcurrentDirection: Vector2 = currentDirection

    if inputDirection.x < 0:
        newcurrentDirection = Vector2.LEFT
    elif inputDirection.x > 0:
        newcurrentDirection = Vector2.RIGHT
    elif inputDirection.y < 0:
        newcurrentDirection = Vector2.UP
    elif inputDirection.y > 0:
        newcurrentDirection = Vector2.DOWN

    set_direction(newcurrentDirection)


func _get_opposite_direction_string(directionString: String) -> String:
    if directionString == 'up':
        return 'down'
    elif directionString == 'right':
        return 'left'
    elif directionString == 'down':
        return 'up'
    else:
        return 'right'


func string_2_direction(directionString: String) -> Vector2:
    if directionString == 'up':
        return Vector2.UP
    elif directionString == 'right':
        return Vector2.RIGHT
    elif directionString == 'down':
        return Vector2.DOWN
    else:
        return Vector2.LEFT


func _set_next_behavior_index() -> void:
    #print("MOVED: ", behaviorChain[currentBehaviorChainIndex])
    currentBehaviorChainIndex += 1

    if currentBehaviorChainIndex >= behaviorChain.size():
        for i in behaviorChain.size():
            behaviorChain[i] = _get_opposite_direction_string(behaviorChain[i])
        behaviorChain.reverse()
        currentBehaviorChainIndex = 0


func _on_area_2d_body_entered(body: Node2D) -> void:
    if body.name != "Player": return
    await Game.get_current_scene().reset_player(PlayerController.ANIMATION_MONSTER)

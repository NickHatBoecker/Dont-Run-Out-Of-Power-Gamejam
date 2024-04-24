extends CharacterBody2D
class_name PlayerController


signal moved
signal moved_finished
signal on_interact


const ANIMATION_FALL = "fall"
const ANIMATION_MONSTER = "monster"


@export var WALK_SPEED: float = 7.0
@export var currentDirection: Vector2 = Vector2.UP
@export var disableMovement: bool = false
@export var disableInput: bool = false


var tileSize: int = 16
var walkSpeed : float = WALK_SPEED

var initialPosition: Vector2 = Vector2(0, 0)
var inputDirection: Vector2 = Vector2(0, 1)
var isMoving: bool = false
var percentMovedToNextTile: float = 0.0


@onready var collisionRay = $RayCast2D
@onready var InteractionShape = $InteractionArea
@onready var animationTree: AnimationTree = $PlayerAnimations/AnimationTree


func _ready():
    initialPosition = position
    inputDirection = currentDirection
    updateInteractionShape()


func _input(event: InputEvent) -> void:
    if disableInput: return

    if event.is_action_pressed("ui_accept"):
        emit_signal("on_interact")


func _physics_process(delta):
    if disableMovement or Store.state.disablePlayerControls or disableInput: return

    if isMoving == false:
        processPlayerMovementInput()

    if inputDirection != Vector2.ZERO:
        move(delta, inputDirection)
    else:
        isMoving = false

    updateSprite(inputDirection)

    emit_signal("moved", {
        "delta": delta,
        "direction": inputDirection,
        "currentDirection": currentDirection,
        "position": position,
        "isColliding": collisionRay.is_colliding()
    })


func setDirection(direction: Vector2):
    currentDirection = direction
    updateSprite(currentDirection)
    updateInteractionShape()


func updateInteractionShape():
    if currentDirection == Vector2.UP:
        InteractionShape.position = Vector2(16, 8)
        InteractionShape.rotation_degrees = 0
    elif currentDirection == Vector2.DOWN:
        InteractionShape.position = Vector2(16, 32)
        InteractionShape.rotation_degrees = 0
    elif currentDirection == Vector2.LEFT:
        InteractionShape.position = Vector2(0, 16)
        InteractionShape.rotation_degrees = 90
    elif currentDirection == Vector2.RIGHT:
        InteractionShape.position = Vector2(24, 16)
        InteractionShape.rotation_degrees = 90


func processPlayerMovementInput():
    walkSpeed = WALK_SPEED

    if inputDirection.y == 0:
        inputDirection.x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
    if inputDirection.x == 0:
        inputDirection.y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))

    if inputDirection != Vector2.ZERO:
        initialPosition = position
        isMoving = true

    var newcurrentDirection: Vector2 = currentDirection

    if inputDirection.x < 0:
        newcurrentDirection = Vector2.LEFT
    elif inputDirection.x > 0:
        newcurrentDirection = Vector2.RIGHT
    elif inputDirection.y < 0:
        newcurrentDirection = Vector2.UP
    elif inputDirection.y > 0:
        newcurrentDirection = Vector2.DOWN

    setDirection(newcurrentDirection)

    return currentDirection != newcurrentDirection


func move(delta, direction: Vector2):
    var desiredStep: Vector2 = direction * tileSize / 2

    collisionRay.target_position = desiredStep
    collisionRay.force_raycast_update()

    percentMovedToNextTile += walkSpeed * delta

    if collisionRay.is_colliding():
        force_stop()
        return

    if percentMovedToNextTile >= 1.0:
        # End moving
        position = initialPosition + (inputDirection * tileSize)
        initialPosition = position
        force_stop()
        emit_signal("moved_finished", position)
    else:
        # Continue moving
        position = initialPosition + (inputDirection * tileSize * percentMovedToNextTile)


func updateSprite(newDirection):
    if newDirection == Vector2.ZERO:
        setIdle()
        return

    animationTree.get("parameters/playback").travel("Walk")
    animationTree.set("parameters/Idle/blend_position", newDirection)
    animationTree.set("parameters/Walk/blend_position", newDirection)


func setIdle() -> void:
    $PlayerAnimations/AnimationTree.get("parameters/playback").travel("Idle")


func play_death_animation(animation: String) -> void:
    if animation == ANIMATION_FALL:
        animationTree["parameters/conditions/is_falling"] = true
        animationTree.get("parameters/playback").travel("Fall")
    else:
        animationTree["parameters/conditions/is_monster_hit"] = true
        animationTree.get("parameters/playback").travel("MonsterHit")

func stop_death_animation(animation: String) -> void:
    if animation == ANIMATION_FALL:
        animationTree["parameters/conditions/is_falling"] = false
    else:
        animationTree["parameters/conditions/is_monster_hit"] = false
    animationTree.get("parameters/playback").travel("Idle")


func force_stop() -> void:
    percentMovedToNextTile = 0.0
    isMoving = false
    inputDirection = Vector2.ZERO

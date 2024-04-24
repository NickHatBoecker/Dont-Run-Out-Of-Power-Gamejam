extends Node2D

signal dialogue_ended


@onready var Balloon = $Balloon
@onready var TextContainer = $Balloon/TextContainer
@onready var Dialogue = $Balloon/TextContainer/DialogueLabel
@onready var Character = $Balloon/TextContainer/CharacterLabel
@onready var SmallText = $SmallText
@onready var MediumText = $MediumText
@onready var PinDown = $PinDown


const FADE_SPEED = 0.02

var dialogueLines: Array = []
var currentCharacter: String = ""
var isWaitingForInput: bool = false
var skipFade:bool = false


func _ready():
    SmallText.hide()
    MediumText.hide()


func _input(event: InputEvent) -> void:
    if !visible: return
    if event.is_action_pressed("ui_accept"):
        if isWaitingForInput:
            if dialogueLines.size() > 0:
                isWaitingForInput = false
                start_dialogue(currentCharacter, dialogueLines)
            else:
                hide()
                emit_signal("dialogue_ended")
                Store.set_disable_player_controls(false)
                _reset()
        else:
            skipFade = true
            await get_tree().create_timer(1).timeout


func start_dialogue(character: String, lines: Array):
    Store.set_disable_player_controls(true)

    dialogueLines = lines
    currentCharacter = character
    var currentLine: String = dialogueLines[0]
    var balloonSize: Vector2 = Vector2.ZERO
    Balloon.size = Vector2.ZERO
    Dialogue.size = Vector2.ZERO

    # Set up character
    if character.is_empty():
        Character.hide()
    else:
        Character.show()
        Character.text = character
        # @TODO Why can't we just use Character.size?
        balloonSize = Vector2(300, 34)

    # Set up dialogue
    _set_text_with_fade(currentLine, 0)

    # Use the size test labels to find the optimum size of balloons for the text
    var bestSize: Vector2 = await _get_best_size(currentLine)

    # Find the text style with the shortest height
    Dialogue.size = bestSize
    Balloon.size = balloonSize + bestSize + Vector2(0, 120)

    Balloon.position = Vector2(
        PinDown.position.x - Balloon.size.x * 0.2,
        PinDown.position.y - Balloon.size.y + 6,
    )

    var target = _find_target(character)
    # You could change color/sound by target

    if target:
        # Position balloon based on speaker
        position = Utils.pixelPosition2position(target.position)
        position = Vector2(position.x + 10, position.y - 20)
    else:
        position = Vector2(300, 300) # @TODO camera center?

    $AnimationPlayer.play("fadeIn")
    await $AnimationPlayer.animation_finished

    await _start_fading_in_text(currentLine)

    isWaitingForInput = true
    dialogueLines.remove_at(0)


## Try some text sizes for the best size
func _get_best_size(text: String) -> Vector2:
    SmallText.text = text
    MediumText.text = text

    SmallText.size = Vector2.ZERO
    MediumText.size = Vector2.ZERO

    # Make sure text is rendered in test styles?
    await get_tree().process_frame

    var shortestHeight: float = INF
    var bestSize: Vector2
    for label in [SmallText, MediumText]:
        if label.get_content_height() <= shortestHeight:
            shortestHeight = label.get_content_height()
            bestSize = Vector2(label.size.x, shortestHeight)
    return bestSize


## Find target for dialogue balloon.
## For example an NPC.
func _find_target(character: String):
    var target = null
    if !character.is_empty():
        var npcs = get_tree().get_nodes_in_group("NPC").filter(
            func(npc): return npc.characterName == character
        )
        if npcs.size() > 0:
            target = npcs[0]
    return target


func _reset() -> void:
    dialogueLines = []
    currentCharacter = ""
    isWaitingForInput = false


func _start_fading_in_text(currentLine: String):
    for i in currentLine.length():
        if skipFade:
            skipFade = false
            _set_text_with_fade(currentLine, currentLine.length())
            return

        _set_text_with_fade(currentLine, i)
        await get_tree().create_timer(FADE_SPEED).timeout


func _set_text_with_fade(dialogueLine: String, fadeLevel: int):
    Dialogue.text = "[fade start=%s length=3]%s[/fade]" % [fadeLevel, dialogueLine]

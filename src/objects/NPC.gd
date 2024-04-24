extends CharacterBody2D


@export var characterName: String = ""
@export var canTalk: bool = false


var playerCollidesWithNpc = false


func _ready() -> void:
    await get_tree().create_timer(1).timeout
    Game.get_player().on_interact.connect(Callable(self, "_on_interact"))


func _on_interact() -> void:
    if !playerCollidesWithNpc: return
    if !canTalk: return

    Game.start_cut_scene()
    Game.start_dialogue(
        "Sarah",
        [
            "Hey %s! Welcome to your new job. Are you ready to rescue some puppies?" % Store.state.playerName,
            "But let me warn you, they are super cute!",
            "Haha, just kidding. I bet you will handle them perfectly."
        ]
    )


func _on_area_entered(area: Area2D) -> void:
    if area.name == "InteractionArea":
        playerCollidesWithNpc = true


func _on_area_exited(area: Area2D) -> void:
    if area.name == "InteractionArea":
        playerCollidesWithNpc = false

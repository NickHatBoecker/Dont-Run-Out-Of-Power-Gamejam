extends Node

## - Der Spieler muss durch einen Hinder-Parkour laufen
## - Es gibt Gegenstände, die ihn behindern
## - Löcher, in die er fallen kann (dann beginnt er wieder vom Startfeld)
## - Gegner, die herum laufen (bei Kollision beginnt man wieder vom Startfeld)
## - der Parkous ist stockfinster
## - der Spieler kann nur mit Hilfe einer Nachtsichtkamera sehen
## - die verliert aber an Energie (Thema Power), je länger man sie benutzt
## - sobald die Energie aufgebraucht ist, muss der Spieler den Parkour blind bestreiten
## - die Zeit, wie lange die Nachtischt verwendet werden kann, hat einen vom Spiel vorgesehenen Standardwert
## - Sobald ein echter Spieler diese Zeit unterbietet, wird das die neue Spielzeit
## - die Zeit ist aber irrelevant für das Abschließen des Levels. Der Spieler kann das Spiel komplett blind abschließen.


var CutSceneBorders = null
var GamePlayer: PlayerController
var GamePlayerCamera: Camera2D
var Flashlight: ColorRect
var CurrentScene: Node2D


func _ready() -> void:
    SceneManager.set_back_limit(3)
    SaveManager.load_game()


func init_game() -> void:
    AudioManager.play_sound("music", "musicLoop")
    init_scene()


func init_scene() -> void:
    var LevelWrapper = get_node("/root/InGame/CurrentScene/SubViewportContainer/SubViewport")
    CurrentScene = LevelWrapper.get_child(0)
    #print("DEBUG: ", currentScene)
    Flashlight = CurrentScene.find_child("Flashlight")
    GamePlayer = CurrentScene.find_child("Player")
    GamePlayerCamera = CurrentScene.find_child("PlayerCamera")
    GamePlayer.moved.connect(Callable(self, '_on_player_moved'))


func get_player() -> PlayerController:
    return GamePlayer


func get_player_camera() -> Camera2D:
    return GamePlayerCamera


func get_flashlight() -> ColorRect:
    return Flashlight


func get_current_scene() -> Node2D:
    return CurrentScene


func _on_player_moved(data: Dictionary) -> void:
    Store.set_player_position({
        "position": data.position,
        "direction": data.currentDirection,
    })

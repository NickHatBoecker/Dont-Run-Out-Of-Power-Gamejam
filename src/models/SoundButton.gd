extends Button
class_name SoundButton


## Unfortunately this doesn't work with grabbing focus yet.
## That's because at the start of a scene render the button will be focused
## and the sound will play. There is no general workaround yet.
var _allow_focus_sfx := false


## Called when the button is pressed.
func _pressed():
    if !disabled:
        AudioManager.play_sound("sfx", "confirm")


func _init() -> void:
    focus_entered.connect(_on_focus_entered)


func grab_focus_no_sfx() -> void:
    _allow_focus_sfx = false
    grab_focus()
    _allow_focus_sfx = true


func _on_focus_entered() -> void:
    if _allow_focus_sfx:
        AudioManager.play_sound("sfx", "select")

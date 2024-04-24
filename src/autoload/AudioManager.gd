extends Node

var availableSfx = {
    # Game
    "fall": preload("res://src/assets/audio/pixabay/invalid-selection-39351.mp3"),
    "monster": preload("res://src/assets/audio/pixabay/monster-death-grunt-131480.mp3"),
    "nightVision": preload("res://src/assets/audio/pixabay/night-vision.mp3"),
    "enterExit": preload("res://src/assets/audio/pixabay/90s-game-ui-6-185099.mp3"),

    # Navigation
    "success": preload("res://src/assets/audio/pixabay/winsquare-6993.mp3"),
    "confirm": preload("res://src/assets/audio/kenney-assets/switch_005.ogg"),
    "select": preload("res://src/assets/audio/kenney-assets/switch_005.ogg"),
    "cancel": preload("res://src/assets/audio/kenney-assets/select_001.ogg"),

    # Audio
    "musicLoop": preload("res://src/assets/audio/pixabay/108_trance_loop-94800.mp3"),
}

## Available audio players
var Players = {
    "sfx": {
        "player": null,
        "isMuted": false,
    },
    "navigation": {
        "player": null,
        "isMuted": false,
    },
    "music": {
        "player": null,
        "isMuted": false,
    },
}


func _ready() -> void:
    Players.sfx.player = AudioPlayers.get_node("sfx")
    Players.navigation.player = AudioPlayers.get_node("sfx")
    Players.music.player = AudioPlayers.get_node("music")


func _process(_delta) -> void:
    for i in Players.keys():
        if Players[i].player: _update_player_volume(i)


## Play sound in given player
func play_sound(playerId: String, sfxId: String) -> void:
    if !availableSfx.has(sfxId): return
    if Players[playerId].isMuted: return

    Players[playerId].player.stream = availableSfx[sfxId]
    Players[playerId].player.playing = true


## Get volume from settings
func get_volume(playerId: String) -> int:
    var storeVar = "%sVolume" % playerId
    var storeValue = 0
    if Settings.vars.has(storeVar):
        storeValue = Settings.vars[storeVar]
    return storeValue


## Set volume to settings and update player
func set_volume(playerId: String, volume: int) -> void:
    var oldMusicValue = get_volume("music")

    var storeVar = "%sVolume" % playerId
    Settings.set_parameter(storeVar, volume)
    _update_player_volume(playerId)

    if playerId != "music": return

    if volume == 0:
        stop_music()
    elif oldMusicValue == 0 and volume != 0:
        play_sound("music", "musicLoop")


func is_playing(playerId: String) -> bool:
    var player: AudioStreamPlayer = Players[playerId].player
    return player.playing


func stop_music() -> void:
    var player: AudioStreamPlayer = Players["music"].player
    player.stop()


## Set volume based on settings value
func _update_player_volume(playerId: String) -> void:
    var storeVar = "%sVolume" % playerId
    var storeValue = 0
    if Settings.vars.has(storeVar):
        storeValue = Settings.vars[storeVar]

    _set_mute_player(playerId, storeValue == 0)
    Players[playerId].player.volume_db = _volume_settings_2_Db(storeValue)


## Default db and the middle of the settings is 0.
## In settings screen 0 should be mute, so we have to translate this value.
## Settings for 5 bars: 0 = -6 (mute), middle = 0, max = 6
func _volume_settings_2_Db(payload: int) -> float:
    if payload <= 0: return 0 # Mute anyway

    if payload == 1: return -6
    if payload == 2: return 0
    if payload == 3: return 3

    return 6 # MAX


## Mute/unmute given player
func _set_mute_player(playerId: String, isMuted: bool) -> void:
    if !Players[playerId].player: return
    Players[playerId].isMuted = isMuted

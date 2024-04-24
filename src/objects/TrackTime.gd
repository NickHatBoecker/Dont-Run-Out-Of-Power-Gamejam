extends Timer
class_name TrackTime


@export var storeVariableName: String = ""


func _ready() -> void:
    wait_time = 1
    start()
    paused = true
    timeout.connect(Callable(self, '_on_time_out'))


func reset() -> void:
    if !Store.state.has(storeVariableName): return
    Store.state[storeVariableName] = 0


func _on_time_out () -> void:
    if !Store.state.has(storeVariableName): return

    var value = Store.state.get(storeVariableName)
    Store.state[storeVariableName] = value + 1

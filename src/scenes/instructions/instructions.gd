extends Control

@onready var Pages = $VBoxContainer/Pages
@onready var Back = $VBoxContainer/Navigation/Wrapper/Back
@onready var Next = $VBoxContainer/Navigation/Wrapper/Next
@onready var Close = $VBoxContainer/Navigation/Wrapper/Close


var currentPage = 1


func _ready() -> void:
    _update_page()


func _process(_delta: float) -> void:
    _update_navigation_visibility()


func _on_back_pressed() -> void:
    currentPage -= 1
    if currentPage <= 1:
        currentPage = 1
        Next.grab_focus()
    _update_page()


func _on_close_pressed() -> void:
    hide()
    Store.set_disable_player_controls(false)


func _on_next_pressed() -> void:
    currentPage += 1
    if currentPage >= Pages.get_children().size():
        currentPage = Pages.get_children().size()
        Close.grab_focus()
    _update_page()


func _update_page() -> void:
    _hide_all_pages()
    Pages.get_node("Page%d" % currentPage).show()


func _update_navigation_visibility() -> void:
    if currentPage == 1:
        Back.modulate.a = 0
    else:
        Back.modulate.a = 100

    if currentPage == Pages.get_children().size():
        Next.modulate.a = 0
    else:
        Next.modulate.a = 100


func _hide_all_pages() -> void:
    for i in Pages.get_children():
        i.hide()


func _on_draw() -> void:
    if Next: Next.grab_focus()
    Store.set_disable_player_controls(true)

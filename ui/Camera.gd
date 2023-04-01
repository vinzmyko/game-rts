extends Camera2D

signal area_selected
signal start_move_selection

@onready var panel = $"../Panel"

var mouse_position: Vector2 = Vector2.ZERO
var mouse_position_global: Vector2 = Vector2.ZERO

var start: Vector2 = Vector2.ZERO
var start_vector: Vector2 = Vector2.ZERO
var end: Vector2 = Vector2.ZERO
var end_vector: Vector2 = Vector2.ZERO
var is_dragging: bool = false


func _ready() -> void:
    # sets panel to be invis at the start
    panel.size *= 0


func _process(_delta) -> void:
    if Input.is_action_just_pressed("left_click"):
        start = mouse_position_global
        start_vector = mouse_position
        is_dragging = true

    if is_dragging:
        end = mouse_position_global
        end_vector = mouse_position
        draw_area(is_dragging)

    if Input.is_action_just_released("left_click"):
        if start_vector.distance_to(mouse_position) > 20:
            end = mouse_position_global
            end_vector = mouse_position
            is_dragging = false
            draw_area(is_dragging)
            emit_signal("area_selected")
        else:
            end = start
            is_dragging = false
            draw_area(false)


func _input(event):
    if event is InputEventMouse:
        mouse_position = event.position
        mouse_position_global = get_global_mouse_position()


func draw_area(s: bool = true):
    panel.size = Vector2(abs(start_vector.x - end_vector.x), abs(start_vector.y - end_vector.y))
    var pos = Vector2.ZERO
    pos.x = min(start_vector.x, end_vector.x)
    pos.y = min(start_vector.y, end_vector.y)
    panel.position = pos
    panel.size *= int(s)

extends Node
const CURSOR = preload("uid://d0icul41gl0br")

func _ready() -> void:
	Input.set_custom_mouse_cursor(CURSOR, Input.CURSOR_ARROW, Vector2(0, 0))
	

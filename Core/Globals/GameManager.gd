extends Node
const CURSOR = preload("uid://d0icul41gl0br")


var drunk_level: int = 5#PODALCZAC
var pulse_speed: float = 5.0#PODALCZAC

var min_scale: float = 0.5# niekoniecznie musimy je podalczac bo malo czasiu mamy
var max_scale: float = 5.0
var curve_power: float = 0.5 

var total_shots: int = 6 #PODALCZAC
var points_needed: int = 500 #PODALCZAC

var min_wheel_speed: int = 25#PODALCZAC
var max_wheel_speed: int = -25#PODALCZAC

enum GAME_STATES{
	SETUP,
	AIM,
	HOLD_SPACE,
	RELEASE_SPACE,
	CHECK_POINTS,
	GAME_OVER
}
var STATE: int = GAME_STATES.SETUP

func _ready() -> void:
	Input.set_custom_mouse_cursor(CURSOR, Input.CURSOR_ARROW, Vector2(0, 0))

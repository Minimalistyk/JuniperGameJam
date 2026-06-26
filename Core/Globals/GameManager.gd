extends Node
const CURSOR = preload("uid://d0icul41gl0br")

var n_round: int = 0
var points_mult: int = 1
var drunk_level: int = 0#PODALCZAC
var pulse_speed: float = 5.0#PODALCZAC

var min_scale: float = 0.5# niekoniecznie musimy je podalczac bo malo czasiu mamy
var max_scale: float = 5.0
var curve_power: float = 0.5 

var total_shots: int = 0 #PODALCZAC
var current_points: int = 0
var points_needed: int = 200 #PODALCZAC # poprawka ma sie skalowac samo!

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
	SignalManager._on_target_hit.connect(update_score_from_target) 


func update_score_from_target(points_earned: int) -> void:
	current_points += points_earned * points_mult

func calculate_next_target() -> void:
	n_round += 1
	var base_expected_value: float = 40.0
	var delta = total_shots * points_mult * base_expected_value * (1.0 + (n_round * 0.1))
	points_needed = current_points + int(delta)

func reset_game_state() -> void:
	n_round = 0
	points_mult = 1
	drunk_level = 0
	total_shots = 0
	current_points = 0
	points_needed = 200 # Wartość startowa, przed pierwszym kołem
	STATE = GAME_STATES.SETUP

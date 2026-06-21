extends Node2D

@onready var crosshair: Node2D = %Crosshair
@onready var game_hud: Control = %GameHUD
#test gameplay vars
@export var test_drunk_level: int
@export var test_pulse_speed: float = 5.0
@export var test_min_scale: float = 0.5
@export var test_max_scale: float = 2.0
@export var test_curve_power: float = 0.5

@export var test_total_shots: int = 0
@export var test_points_needed: int = 0
@export var test_points_mult: float = 1

func _ready() -> void:
	SignalManager._on_dagger_thrown.connect(markit)
	setup()

func setup() -> void:
	#crosshair
	crosshair.drunk_level = test_drunk_level
	crosshair.pulse_speed = test_pulse_speed
	crosshair.min_scale = test_min_scale
	crosshair.max_scale = test_max_scale
	crosshair.curve_power = test_curve_power
	crosshair.start_game()
	#hud
	game_hud.total_shots = test_total_shots
	game_hud.points_needed = test_points_needed
	game_hud.start_game()

func markit(pos: Vector2) -> void:
	test_total_shots -= 1
	SignalManager.emit_on_create_object(pos, Constants.OBJECT_TYPE.DEBUG_POINT)
	if test_total_shots == 0:
		print("koniec!")

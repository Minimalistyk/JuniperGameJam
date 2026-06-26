class_name MainGame
extends Node2D

@onready var node_2d: Node2D = %Node2D
@onready var target: Area2D = %Target
@onready var crosshair: Node2D = %Crosshair
@onready var game_hud: Control = %GameHUD
@onready var gameover_node: gameover_hud = %Gameover
@onready var baloons: TextureRect = %Baloons

var drunk_level: int
var pulse_speed: float = 5.0
var min_scale: float = 0.3
var max_scale: float = 3.75
var curve_power: float = 0.75

var total_shots: int = 10 
var points_needed: int = 500
var points_mult: float = 1.5 

func _ready() -> void:
	baloons.position.y = 1440
	drunk_level = GameManager.drunk_level
	target.position = Vector2(20*drunk_level,20*drunk_level)
	total_shots = GameManager.total_shots
	points_mult = GameManager.points_mult
	
	SignalManager._on_dagger_thrown.connect(decrese_shot)
	GameManager.STATE = GameManager.GAME_STATES.AIM
	setup()

func _process(delta: float) -> void:
	if GameManager.STATE == GameManager.GAME_STATES.AIM:
		var current_spin_speed = 20 + (15 * sqrt(drunk_level))
		node_2d.rotation_degrees -= current_spin_speed * delta

func checkwin() -> bool:
	if GameManager.STATE == GameManager.GAME_STATES.CHECK_POINTS:
		if GameManager.current_points >= GameManager.points_needed: 
			GameManager.STATE = GameManager.GAME_STATES.SETUP 
			baloons.visible = true
			var tween = create_tween()
			AudioManager.play_sfx("WIN")
			tween.tween_method(func(progress: float):
				baloons.position.y = lerp(1440, -1440, progress)
				baloons.position.x = sin(progress * 15.0) * 30.0, 0.0, 1.0, 3)
			tween.tween_callback(func(): 
				baloons.position.y = 1440
				baloons.position.x = 0
				SceneManager.change_scene_to(Constants.SCENES.MENU_WHEEL))
			return true 
		elif total_shots > 0:
			GameManager.STATE = GameManager.GAME_STATES.AIM
	return false

func setup() -> void:
	game_hud.start_game()

func decrese_shot(_pos: Vector2) -> void:
	total_shots -= 1 
	game_hud.update_daggers(total_shots)
	
	if checkwin():
		return
	if total_shots == 0:
		GameManager.STATE = GameManager.GAME_STATES.GAME_OVER
		gameover()

func gameover() -> void:
	await get_tree().create_timer(1).timeout
	gameover_node.show_gameover(GameManager.current_points)

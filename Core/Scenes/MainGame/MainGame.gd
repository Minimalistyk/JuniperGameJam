class_name MainGame
extends Node2D

@onready var node_2d: Node2D = %Node2D
@onready var target: Area2D = %Target
@onready var crosshair: Node2D = %Crosshair
@onready var game_hud: Control = %GameHUD
@onready var gameover_node: gameover_hud = %Gameover
@onready var baloons: TextureRect = %Baloons

# test gameplay vars
var drunk_level: int
var pulse_speed: float = 5.0
var min_scale: float = 0.5
var max_scale: float = 2.0
var curve_power: float = 0.5

var total_shots: int = 10 # Przykładowa wartość początkowa
var points_needed: int = 500
var points_mult: float = 1.5 # Mnożnik punktów, o którym pisał znajomy
var current_score: int = 0

func _ready() -> void:
	baloons.position.y = 1440
	drunk_level = GameManager.drunk_level
	target.position = Vector2(25*drunk_level,25*drunk_level)
	total_shots = GameManager.total_shots
	SignalManager._on_dagger_thrown.connect(decrese_shot)
	SignalManager._on_target_hit.connect(on_target_hit)
	GameManager.STATE = GameManager.GAME_STATES.AIM
	setup()

func _process(delta: float) -> void:
	if GameManager.STATE == GameManager.GAME_STATES.AIM:
		node_2d.rotation_degrees -= 45 * drunk_level * delta

func checkwin() -> bool:
	if GameManager.STATE == GameManager.GAME_STATES.CHECK_POINTS:
		if current_score >= points_needed: 
			var tween = create_tween()
			tween.tween_method(func(progress: float):
				baloons.position.y = lerp(1440, -1440, progress)
				baloons.position.x = sin(progress * 15.0) * 30.0, 0.0, 1.0, 3)
			tween.tween_callback(func(): 
				baloons.position.y = 1440
				baloons.position.x = 0
				#SceneManager.change_scene_to()# tu scena na ktorej losujemy te nasze zmienne 
				return true)
		elif total_shots>0:
			GameManager.STATE = GameManager.GAME_STATES.AIM
	return false

	

func setup() -> void:
	# Załóżmy, że HUD ma funkcję aktualizacji punktów lub zmienną score
	if game_hud.has_method("update_score"):
		game_hud.update_score(current_score)
	game_hud.start_game()


func decrese_shot(_pos: Vector2) -> void:
	total_shots -= 1 
	if checkwin():
		return
	if total_shots == 0:
		GameManager.STATE = GameManager.GAME_STATES.GAME_OVER
		gameover()

func on_target_hit(points: int) -> void:
	current_score += points

func gameover() -> void:
	gameover_node.show_gameover(current_score)
	

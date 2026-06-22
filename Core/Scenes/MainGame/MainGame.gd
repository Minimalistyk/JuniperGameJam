extends Node2D

@onready var node_2d: Node2D = %Node2D
@onready var target: Area2D = %Target
@onready var crosshair: Node2D = %Crosshair
@onready var game_hud: Control = %GameHUD

# test gameplay vars
@export var test_drunk_level: int
@export var test_pulse_speed: float = 5.0
@export var test_min_scale: float = 0.5
@export var test_max_scale: float = 2.0
@export var test_curve_power: float = 0.5

@export var test_total_shots: int = 10 # Przykładowa wartość początkowa
@export var test_points_needed: int = 500
@export var test_points_mult: float = 1.5 # Mnożnik punktów, o którym pisał znajomy
var current_score: int = 0

func _ready() -> void:
	SignalManager._on_dagger_thrown.connect(markit)
	# PODŁĄCZENIE NOWEGO SYGNAŁU Z TARCZY:
	SignalManager.on_target_hit.connect(_on_target_hit)
	setup()

func setup() -> void:
	# crosshair
	crosshair.drunk_level = test_drunk_level
	crosshair.pulse_speed = test_pulse_speed
	crosshair.min_scale = test_min_scale
	crosshair.max_scale = test_max_scale
	crosshair.curve_power = test_curve_power
	crosshair.start_game()
	
	# hud
	game_hud.total_shots = test_total_shots
	game_hud.points_needed = test_points_needed
	# Załóżmy, że HUD ma funkcję aktualizacji punktów lub zmienną score
	if game_hud.has_method("update_score"):
		game_hud.update_score(current_score)
	game_hud.start_game()
	
	

func markit(pos: Vector2) -> void:
	test_total_shots -= 1
	
	# 1. Sprawdzamy, czy trafiliśmy w tarczę
	var hit_on_target: bool = false
	if is_instance_valid(target):
		var distance = target.global_position.distance_to(pos)
		if distance < target.max_radius:
			hit_on_target = true
			
	# 2. Znajdujemy ObjectMakera w scenie (zakładamy, że nazywa się %ObjectMaker lub po prostu ObjectMaker)
	var maker = get_node_or_null("%ObjectMaker")
	if not maker:
		maker = get_node_or_null("ObjectMaker")

	# 3. Tworzymy obiekt bezpośrednio przez ObjectMakera, omijając SignalManagera
	# Wywołujemy ObjectMakera bezpośrednio
	if maker and maker.has_method("on_create_object"):
		if hit_on_target:
			# KLUCZOWA ZMIANA: Przekazujemy target.target_wheel zamiast samego target!
			if is_instance_valid(target) and "target_wheel" in target:
				maker.on_create_object(pos, Constants.OBJECT_TYPE.DEBUG_POINT, target.target_wheel)
			else:
				maker.on_create_object(pos, Constants.OBJECT_TYPE.DEBUG_POINT, target)
				
			target.hit_target(pos)
		else:
			# Pudło! Punkt tworzy się normalnie w świecie gry
			maker.on_create_object(pos, Constants.OBJECT_TYPE.DEBUG_POINT)
	# Aktualizacja HUD
	game_hud.total_shots = test_total_shots
	if game_hud.has_method("update_shots"):
		game_hud.update_shots(test_total_shots)
		
	if test_total_shots == 0:
		print("koniec!")

	# HUD
	game_hud.total_shots = test_total_shots
	if game_hud.has_method("update_shots"):
		game_hud.update_shots(test_total_shots)
		
	if test_total_shots == 0:
		print("koniec!")

func _on_target_hit(points: int) -> void:
	current_score += points
	print("Trafiono tarcze! Punkty: ", points, " Total score: ", current_score)
	
	# Bezpośrednio aktualizujemy punkty w HUDzie przy użyciu nowej funkcji
	if is_instance_valid(game_hud):
		game_hud.update_score_from_target(points)
		
func _process(delta: float) -> void:
	node_2d.rotation_degrees += 20 * delta

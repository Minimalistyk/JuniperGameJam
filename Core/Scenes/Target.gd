extends Area2D


var max_radius: float = 0.0

var rotation_speed: float = 0.0
var min_rotation_speed: float = 0
var max_rotation_speed: float = 0

@onready var target_wheel: Sprite2D = $TargetWheel
@onready var collision_shape_2d: CollisionShape2D = $CircleShape2D

func _ready() -> void:
	SignalManager._on_dagger_thrown.connect(hit_target)
	min_rotation_speed = GameManager.min_wheel_speed
	max_rotation_speed = GameManager.max_wheel_speed
	if collision_shape_2d and collision_shape_2d.shape is CircleShape2D:
		max_radius = collision_shape_2d.shape.radius
	else:
		max_radius = 300.0 
	
	randomize_movement()

func _process(delta: float) -> void:
	if GameManager.STATE == GameManager.GAME_STATES.AIM:
		rotation_degrees += rotation_speed * delta
	if GameManager.STATE == GameManager.GAME_STATES.CHECK_POINTS:
		randomize_movement()

func randomize_movement() -> void:
	rotation_speed = randf_range(-min_rotation_speed, max_rotation_speed)

func hit_target(hit_position: Vector2) -> void:
	# Liczymy odległość uderzenia od środka tarczy
	var distance = global_position.distance_to(hit_position)
	var base_points = 0
	
	# Jeśli trafiliśmy w obręb automatycznie wykrytego promienia tarczy
	if distance < max_radius:
		# Obliczamy szerokość jednego pierścienia (dzielimy tarczę na 7 równych części)
		var ring_width = max_radius / 7.0
		
		if distance <= ring_width:
			base_points = 100
		elif distance <= ring_width * 2.0:
			base_points = 75
		elif distance <= ring_width * 3.0:
			base_points = 50
		elif distance <= ring_width * 4.0:
			base_points = 30
		elif distance <= ring_width * 5.0:
			base_points = 20
		elif distance <= ring_width * 6.0:
			base_points = 10
		else:
			base_points = 5
	else:
		base_points = 0
	# Wysłanie sygnału, jeśli przyznano punkty
	if base_points > 0:
		AudioManager.play_target_sound()
		SignalManager.emit_on_target_hit(base_points)
		SignalManager.emit_on_create_object(hit_position, Constants.OBJECT_TYPE.DEBUG_POINT, self)

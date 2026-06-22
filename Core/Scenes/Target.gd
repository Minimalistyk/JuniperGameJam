extends Area2D

# 1. Definiujemy stany (State Machine)
enum State { CELOWANIE, TRZYMANIE, RESET }
var current_state: State = State.CELOWANIE

# Zmienna na promień – już bez @export i bez wpisanej na sztywno liczby!
var max_radius: float = 0.0

# Zmienna do prędkości obrotu
var rotation_speed: float = 0.0

@onready var target_wheel: Sprite2D = $TargetWheel
# Pobieramy referencję do naszego węzła kolizji z drzewa sceny
@onready var collision_shape_2d: CollisionShape2D = $CircleShape2D

func _ready() -> void:
	# --- AUTOMATYCZNE PRZYPISANIE PROMIENIA ---
	# Sprawdzamy czy węzeł kolizji istnieje i czy ma przypisany kształt
	if collision_shape_2d and collision_shape_2d.shape is CircleShape2D:
		max_radius = collision_shape_2d.shape.radius
		print("Automatycznie pobrano promien tarczy: ", max_radius)
	else:
		# Wartość awaryjna, gdyby coś poszło nie tak
		max_radius = 300.0 
		print("Nie znaleziono CircleShape2D, ustawiono domyslny promien: ", max_radius)
	# ------------------------------------------
	
	randomize_movement()

func _process(delta: float) -> void:
	match current_state:
		State.CELOWANIE:
			rotation += rotation_speed * delta
			if Input.is_action_pressed("ui_accept"):
				current_state = State.TRZYMANIE
		State.TRZYMANIE:
			if Input.is_action_just_released("ui_accept"):
				current_state = State.CELOWANIE
		State.RESET:
			randomize_movement()
			current_state = State.CELOWANIE

func randomize_movement() -> void:
	rotation_speed = randf_range(-4.0, 4.0)

func hit_target(hit_position: Vector2) -> void:
	# Liczymy odległość uderzenia od środka tarczy
	var distance = global_position.distance_to(hit_position)
	var base_points = 0
	
	# Jeśli trafiliśmy w obręb automatycznie wykrytego promienia tarczy
	if distance < max_radius:
		# Obliczamy szerokość jednego pierścienia (dzielimy tarczę na 7 równych części)
		var ring_width = max_radius / 7.0
		
		# Sprawdzamy kolejno pierścienie od środka na zewnątrz
		if distance <= ring_width:
			# Strefa 1 (Sam środek - Bullseye)
			base_points = 100
			print("STREFA 1 (ŚRODEK): 100 pkt")
		elif distance <= ring_width * 2.0:
			# Strefa 2
			base_points = 75
			print("STREFA 2: 75 pkt")
		elif distance <= ring_width * 3.0:
			# Strefa 3
			base_points = 50
			print("STREFA 3: 50 pkt")
		elif distance <= ring_width * 4.0:
			# Strefa 4
			base_points = 30
			print("STREFA 4: 30 pkt")
		elif distance <= ring_width * 5.0:
			# Strefa 5
			base_points = 20
			print("STREFA 5: 20 pkt")
		elif distance <= ring_width * 6.0:
			# Strefa 6
			base_points = 10
			print("STREFA 6: 10 pkt")
		else:
			# Strefa 7 (Zewnętrzny brzeg tarczy)
			base_points = 5
			print("STREFA 7 (BRZEG): 5 pkt")
	else:
		# Całkowite pudło (poza max_radius)
		base_points = 0
		
	# Wysłanie sygnału, jeśli przyznano punkty
	if base_points > 0:
		SignalManager.emit_signal("on_target_hit", base_points)
		current_state = State.RESET

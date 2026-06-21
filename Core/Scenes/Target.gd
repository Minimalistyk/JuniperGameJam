extends Area2D


enum State { CELOWANIE, TRZYMANIE, RESET }
var current_state: State = State.CELOWANIE

var rotation_speed: float = 0.0

func _ready() -> void:
	randomize_movement()

func _process(delta: float) -> void:
	# Obsługa stanów
	match current_state:
		State.CELOWANIE:
			# Obracamy tarczę w miejscu wokół własnej osi
			rotation += rotation_speed * delta
			
			# Jeśli gracz wciśnie spację -> tarcza staje w miejscu
			if Input.is_action_pressed("ui_accept"): # "ui_accept" to domyślnie Spacja
				current_state = State.TRZYMANIE

		State.TRZYMANIE:
			# Tarcza stoi w miejscu (brak modyfikacji rotation)
			# Jeśli gracz puści spację -> wraca do kręcenia
			if Input.is_action_just_released("ui_accept"):
				current_state = State.CELOWANIE

		State.RESET:
			# Losujemy nową prędkość/kierunek i wracamy do kręcenia
			randomize_movement()
			current_state = State.CELOWANIE

# Funkcja losująca prędkość obrotu (dodatnia w prawo, ujemna w lewo)
func randomize_movement() -> void:
	rotation_speed = randf_range(-4.0, 4.0)

func hit_target(hit_position: Vector2) -> void:
	# Liczymy odległość noża od punktu (0,0) tarczy
	var distance = global_position.distance_to(hit_position)
	
	var max_radius = 251.01
	var base_points = 0
	
	if distance < max_radius:
		# Remap działa tak: 
		# odległość 0 (sam środek) -> 100 punktów
		# odległość 400 (skraj tarczy) -> 10 punktów
		base_points = int(remap(distance, 0, max_radius, 100, 10))
	
	# Jeśli trafiliśmy gdziekolwiek w obrębie promienia 400 (punkty > 0)
	if base_points > 0:
		SignalManager.emit_signal("on_target_hit", base_points)
		current_state = State.RESET

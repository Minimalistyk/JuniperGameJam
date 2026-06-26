extends Node2D
@onready var sprite: Sprite2D = %Sprite2D

var rotation_speed: float
var drunk_level: int
var pulse_speed: float = 5.0
var min_scale: float = 0.5
var max_scale: float = 5.0
var curve_power: float = 0.5
var wandering_time: float
var charging_time: float
var starting_scale: Vector2
var current_pattern: int = 0

func _ready() -> void: 
	starting_scale = sprite.scale
	reset()
	curve_power -= drunk_level * 0.05 #to jest od tego jak celownik przyspiesza zmaine rozmairu gdy jest maly
	curve_power = clampf(curve_power, 0.2, 0.5)
	
	

func reset() -> void:
	drunk_level = GameManager.drunk_level
	pulse_speed = GameManager.pulse_speed
	
	sprite.scale = starting_scale
	rotation_speed = 0.5 + (sqrt(drunk_level) * 0.5)
	sprite.offset = Vector2(2*drunk_level,2*drunk_level)
	charging_time = 0
	wandering_time = 0
	current_pattern = randi() % 3

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and GameManager.STATE == GameManager.GAME_STATES.AIM:
		GameManager.STATE = GameManager.GAME_STATES.HOLD_SPACE
		sprite.position+=sprite.offset*sprite.scale # ustawiamy sprite w centrum a offset na 0 zeby celowanie bylo na srodku
		sprite.offset = Vector2.ZERO
	if event.is_action_released("ui_accept") and GameManager.STATE == GameManager.GAME_STATES.HOLD_SPACE:
		GameManager.STATE = GameManager.GAME_STATES.RELEASE_SPACE


func _physics_process(delta: float) -> void:
	if GameManager.STATE == GameManager.GAME_STATES.AIM:
		wandering_time += delta 
		rotation += rotation_speed * delta
		#global_position = lerp(global_position, get_global_mouse_position(), 0.1)#goni za myszka
		var follow_speed = max(12.0 - (drunk_level * 0.5), 3.0) # Im bardziej pijany, tym wolniej goni
		global_position = global_position.lerp(get_global_mouse_position(), 1.0 - exp(-follow_speed * delta))
		#sprite.position = Vector2(drunk_level * sin(wandering_time), drunk_level * sin(2*wandering_time))#kolaecczka walil
		sprite.position = get_drunk_offset(wandering_time, drunk_level, current_pattern)
	elif GameManager.STATE == GameManager.GAME_STATES.HOLD_SPACE:
		charging_time += delta 
		var raw_sin = sin(charging_time * pulse_speed)
		var pulse_factor = (raw_sin + 1.0) / 2.0
		pulse_factor = pow(pulse_factor, curve_power)
		var current_size = lerp(min_scale, max_scale, pulse_factor)
		sprite.scale = Vector2(current_size, current_size)
	elif GameManager.STATE == GameManager.GAME_STATES.RELEASE_SPACE:
		var random_dist = sqrt(randf()) * 8 * sprite.scale.x#promien sprita skoro mam 16x16 to promien to 8 piskeli * skala 
		var hit_offset = Vector2.from_angle(randf() * TAU) * random_dist # randf() * TAU to losowy kont
		var final_hit_position = sprite.global_position + hit_offset
		GameManager.STATE = GameManager.GAME_STATES.CHECK_POINTS
		SignalManager.emit_on_dagger_thrown(final_hit_position)
		reset()


func get_drunk_offset(time: float, level: int, pattern: int) -> Vector2:
	var target_pos := Vector2.ZERO
	var sway_intensity = 10.0 + (8.0 * sqrt(level)) 

	match pattern:
		0: target_pos = Vector2(sin(time), sin(2 * time)) # Klasyczna ósemka Lissajous
		1: target_pos = Vector2(cos(time * 1.2), sin(time * 0.8)) # Pijana elipsa
		2: target_pos = Vector2(sin(time * 2.5), cos(time * 3.1 + 1.0)) # Asymetryczne szarpanie

	return target_pos * sway_intensity

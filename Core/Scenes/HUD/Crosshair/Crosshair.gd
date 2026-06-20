extends Node2D
@onready var sprite: Sprite2D = %Sprite2D

var rotation_speed: float
var drunk_level: int
var pulse_speed: float = 5.0
var min_scale: float = 0.5
var max_scale: float = 2.0
var curve_power: float = 0.5
var wandering_time: float
var charging_time: float
var starting_scale: Vector2
var state: int
enum stateList { WANDERING, CHARGING, SHOT, WAIT }

func start_game() -> void: #to nie jest _ready!
	set_varibles()
	curve_power -= drunk_level * 0.05 #to jest od tego jak celownik przyspiesza zmaine rozmairu gdy jest maly
	curve_power = clampf(curve_power, 0.2, 0.5)
	starting_scale = sprite.scale
	reset()

func set_varibles():
	pass

func reset() -> void:
	sprite.scale = starting_scale
	rotation_speed = drunk_level
	sprite.offset = Vector2(2*drunk_level,2*drunk_level)
	state = stateList.WANDERING
	charging_time = 0
	wandering_time = 0

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and state == stateList.WANDERING:
		state = stateList.CHARGING
		sprite.position+=sprite.offset*sprite.scale # ustawiamy sprite w centrum a offset na 0 zeby celowanie bylo na srodku
		sprite.offset = Vector2.ZERO
	if event.is_action_released("ui_accept") and state == stateList.CHARGING:
		state = stateList.SHOT


func _physics_process(delta: float) -> void:
	if state == stateList.WANDERING:
		wandering_time += delta 
		rotation += rotation_speed * delta
		global_position = lerp(global_position, get_global_mouse_position(), 0.1)#goni za myszka
		sprite.position = Vector2(drunk_level * sin(wandering_time), drunk_level * sin(2*wandering_time))#chwieje sie na boki
	elif state == stateList.CHARGING:
		charging_time += delta 
		var raw_sin = sin(charging_time * pulse_speed)
		var pulse_factor = (raw_sin + 1.0) / 2.0
		pulse_factor = pow(pulse_factor, curve_power)
		var current_size = lerp(min_scale, max_scale, pulse_factor)
		sprite.scale = Vector2(current_size, current_size)
	elif state == stateList.SHOT:
		var random_dist = sqrt(randf()) * 8 * sprite.scale.x#promien sprita skoro mam 16x16 to promien to 8 piskeli * skala 
		var hit_offset = Vector2.from_angle(randf() * TAU) * random_dist # randf() * TAU to losowy kont
		var final_hit_position = sprite.global_position + hit_offset
		SignalManager.emit_on_dagger_thrown(final_hit_position)
		state = stateList.WAIT
	elif state == stateList.WAIT:
		if Input.is_action_just_pressed("ui_up"):
			state = stateList.WANDERING
			reset()
		
	

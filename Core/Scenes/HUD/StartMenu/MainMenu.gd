extends Control

const CURSOR_AXE = preload("res://assets/axe_cursor.png")
@onready var target_wheel: TextureRect = %TargetWheel
@onready var wheel_container: Control = %WheelContainer
@onready var hit_sound: AudioStreamPlayer = $HitSound

var time_passed: float = 0.0

func _ready():
	Input.set_custom_mouse_cursor(CURSOR_AXE, Input.CURSOR_ARROW, Vector2(0, 0))
	
	target_wheel.pivot_offset = target_wheel.size / 2

func _process(delta):
	time_passed += delta
	
	var wave = sin(time_passed * 0.75)
	
	target_wheel.rotation_degrees = wave * 35 + 45


func play_hit_effect():
	if hit_sound:
		hit_sound.play()
	
	var tween = create_tween()
	var original_pos = wheel_container.position
	
	tween.tween_property(wheel_container, "position", original_pos + Vector2(0, 8), 0.04)
	tween.tween_property(wheel_container, "position", original_pos - Vector2(0, 4), 0.04)
	tween.tween_property(wheel_container, "position", original_pos, 0.04)

func _on_start_button_pressed():
	play_hit_effect()
	await get_tree().create_timer(0.4).timeout
	
func _on_options_button_pressed():
	play_hit_effect()
	await get_tree().create_timer(0.4).timeout
	
func _on_info_button_pressed():
	play_hit_effect()
	await get_tree().create_timer(0.4).timeout
	
func _on_exit_button_pressed():
	play_hit_effect()
	await get_tree().create_timer(0.4).timeout
	get_tree().quit()

class_name MenuWheel
extends Control

@onready var start_button: Button = %StartButton

@export var start_button_text: String = "START"

var time_passed: float = 0

func _ready():
	pivot_offset = size / 2
	start_button.text = start_button_text

func _process(delta):
	wheel_rotate_anim(delta)


func wheel_rotate_anim(delta: float) -> void:
	time_passed += delta
	var wave = sin(time_passed * 0.75)
	rotation_degrees = wave * 35 + 45

func button_pressed_anim() -> void:
	var original_pos = position
	AudioManager.play_click()
	
	var tween = create_tween()
	tween.tween_property(self, "position", original_pos + Vector2(0, 8), 0.04)
	tween.tween_property(self, "position", original_pos - Vector2(0, 4), 0.04)
	tween.tween_property(self, "position", original_pos, 0.04)


func _on_start_button_pressed() -> void:
	button_pressed_anim()
	SignalManager.emit_on_start_button_pressed()

func _on_info_button_pressed() -> void:
	button_pressed_anim()
	SignalManager.emit_on_credits_button_pressed()

func _on_options_button_pressed() -> void:
	button_pressed_anim()
	SignalManager.emit_on_options_button_pressed()

func _on_exit_pressed() -> void:
	button_pressed_anim()
	SignalManager.emit_on_quit_button_pressed()

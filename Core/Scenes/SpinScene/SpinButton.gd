extends Node

@export var wheel: TextureRect
@onready var shots_label: Label = %ShotsLabel
@onready var mult_label: Label = %MultLabel
@onready var drunk_label: Label = %DrunkLabel
@onready var desc: Label = %Desc
@onready var desc2: Label = %Desc2
@onready var reroll_button: Button = %RerollButton
@onready var what_is_rolling: Label = %WhatIsRolling

@onready var spin_button: Button = %SpinButton
@onready var spinleftlabel: Label = %spinleftlabel
@onready var rereollspinleft: Label = %rereollspinleft
@onready var info: Button = %INFO

var winning_numbers := {
	"1" : 1,
	"2" : 3,
	"3" : 5,
	"4" : 2,
}

@onready var labels := {
	"3" : shots_label,
	"2" : mult_label,
	"1" : drunk_label,
}

var whatisrolling :={
	"3" : "ROLL: SHOTS",
	"2" : "ROLL: MULT",
	"1" : "ROLL: DRUNK",
	"0" : "PRESS SPACE TO CONTINUE!"
}

var speed_deg := 0.0
var spinning := false
var spin_time_left := 0.0
var spin_time_start := 0.0
var amount_of_spins := 3
var time: float = 0
var can_reroll: bool = true

var tick_step: float = 22.5 
var next_tick_angle: float = 0.0

func spin_wheel() -> void: #podlaczone od spin button 
	AudioManager.play_click()
	if spinning: 
		return
	
	spinning = true
	spin_button.disabled = true 
	spin_time_left = randf_range(2.0, 3.0)
	spin_time_start = spin_time_left
	
	next_tick_angle = wheel.rotation_degrees + tick_step

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and amount_of_spins == 0:
		GameManager.calculate_next_target()
		
		GameManager.STATE = GameManager.GAME_STATES.SETUP
		SceneManager.change_scene_to(Constants.SCENES.MAIN_GAME)

func _process(delta: float) -> void:
	what_is_rolling.text = str(whatisrolling[str(amount_of_spins)])
	spinleftlabel.text = str(amount_of_spins) + "/3"
	rereollspinleft.text = str(int(can_reroll)) + "/1"
	
	if amount_of_spins == 3 or spinning or !can_reroll:
		reroll_button.disabled = true
	else:
		reroll_button.disabled = false
		
	time += delta
	var s = (sin(time/4) + 1.5) / 4.0 + 1.05
	desc.scale = Vector2(s, s)
	desc2.scale = Vector2(s, s)
	if spinning: 
		if spin_time_left < spin_time_start / 2.0:
			speed_deg = max(speed_deg - 1000 * delta, 0.0)
		else:
			speed_deg += 1000.0 * delta
			
		wheel.rotation += deg_to_rad(speed_deg) * delta
		spin_time_left -= delta
		
		while wheel.rotation_degrees >= next_tick_angle:
			AudioManager.play_sfx("TICK", true)
			next_tick_angle += tick_step
		
		if speed_deg <= 0:
			spinning = false
			if amount_of_spins != 1:
				spin_button.disabled = false
				
			var x : int = int(wheel.rotation_degrees) % 360
			var y : int = int(x / 90.0) + 1
			var nowa_wartosc = winning_numbers[str(y)]
			
			match amount_of_spins:
				3:
					GameManager.total_shots = nowa_wartosc * 2
					labels["3"].text = str(nowa_wartosc)
				2:
					GameManager.points_mult = nowa_wartosc
					labels["2"].text = str(nowa_wartosc)
				1:
					GameManager.drunk_level += nowa_wartosc
					labels["1"].text = str(nowa_wartosc)
					
			amount_of_spins -= 1

func _on_reroll_button_2_pressed() -> void: #rerol but podlaczony
	amount_of_spins += 1
	can_reroll = false
	spin_wheel()


func _on_info_pressed() -> void: #info podlaczone 
	desc.show()
	desc2.show()
	info.disabled = true
	AudioManager.play_sfx("BREAK", true)
	info.pivot_offset = Vector2.ZERO
	var tween = create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(info, "position:y", info.position.y + 1000.0, 0.8)
	var random_rotation = randf_range(45.0, 90.0)
	tween.tween_property(info, "rotation_degrees", random_rotation, 0.8)
	tween.set_parallel(false)
	tween.tween_callback(func(): info.visible = false)

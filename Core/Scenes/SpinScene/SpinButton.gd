extends Button

@export var wheel: TextureRect
@onready var shots_label: Label = %ShotsLabel
@onready var mult_label: Label = %MultLabel
@onready var drunk_label: Label = %DrunkLabel
@onready var desc: Label = %Desc
@onready var reroll_button: Button = %RerollButton
@onready var what_is_rolling: Label = %WhatIsRolling

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

var speed_deg := 0
var spinning := false
var spin_time_left := 0.0
var spin_time_start := 0.0
var amount_of_spins := 3
var time: float = 0
var can_reroll: bool = true


var tick_step: float = 22.5 
var next_tick_angle: float = 0.0

func _pressed():
	AudioManager.play_click()
	if spinning: 
		return
	
	spinning = true
	disabled = true
	spin_time_left = randf_range(2.0, 3.0)
	spin_time_start = spin_time_left
	
	next_tick_angle = wheel.rotation_degrees + tick_step

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and amount_of_spins == 0:
		GameManager.calculate_next_target()
		
		GameManager.STATE = GameManager.GAME_STATES.SETUP
		SceneManager.change_scene_to(Constants.SCENES.MAIN_GAME)

func _process(delta):
	what_is_rolling.text = str(whatisrolling[str(amount_of_spins)])
	
	if amount_of_spins == 3 or spinning or !can_reroll:
		reroll_button.disabled = true
	else:
		reroll_button.disabled = false
		
	time += delta
	var s = (sin(time)+1.5) / 4 + 1.05
	desc.scale = Vector2(s,s)
	
	if spinning:
		if spin_time_left < spin_time_start/2:
			speed_deg = max(speed_deg - 1000 * delta, 0.0)
		else:
			speed_deg += 1000 * delta 
			
		wheel.rotation += deg_to_rad(speed_deg) * delta
		spin_time_left -= delta
		

		while wheel.rotation_degrees >= next_tick_angle:
			AudioManager.play_sfx("TICK", true)
			next_tick_angle += tick_step
		
		if speed_deg <= 0:
			spinning = false
			if amount_of_spins != 1:
				disabled = false
				
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

func _on_reroll_button_2_pressed() -> void:
	amount_of_spins += 1
	can_reroll = false
	_pressed()

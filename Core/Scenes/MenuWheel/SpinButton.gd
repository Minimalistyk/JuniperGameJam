extends Button

@export var wheel: TextureRect

var winning_numbers := {
	"1" : 1,
	"2" : 3,
	"3" : 5,
	"4" : 2,
}
var thing_to_set := {
	"2" : GameManager.points_mult,
	"1" : GameManager.drunk_level,
}

var speed_deg := 0
var spinning := false
var spin_time_left := 0
var spin_time_start := 0
var amount_of_spins := 2


func _pressed():
	if spinning: 
		return
		
	spinning = true
	disabled = true
	spin_time_left = randf_range(600, 800)
	spin_time_start = spin_time_left
	

func _process(delta):
	if spinning:
		if spin_time_left < spin_time_start/2:
			speed_deg = max(speed_deg - 1000 * delta, 0.0)
		else:
			speed_deg += 1000 * delta 
		wheel.rotation += deg_to_rad(speed_deg) * delta
		spin_time_left -= delta
		if speed_deg <= 0:
			spinning = false
			if amount_of_spins == 2:
				disabled = false
			var x := int(wheel.rotation_degrees) % 360
			var y := x / 90 + 1

			thing_to_set[str(amount_of_spins)] = winning_numbers[str(y)]
			print(thing_to_set[str(amount_of_spins)])
			amount_of_spins -= 1
			

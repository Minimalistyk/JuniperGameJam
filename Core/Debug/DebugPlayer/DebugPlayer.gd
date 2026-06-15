extends Sprite2D
@onready var debug_player: Sprite2D = $"."
@export var move_speed: float = 250

func _physics_process(delta: float) -> void: #bardzo ciluaty kod jak chcesz go przepisac to prosze bardzo
	var moveh: float = Input.get_axis("ui_left", "ui_right")
	position.x += moveh * delta * move_speed
	var movev: float = Input.get_axis("ui_up", "ui_down")
	position.y += movev * delta * move_speed

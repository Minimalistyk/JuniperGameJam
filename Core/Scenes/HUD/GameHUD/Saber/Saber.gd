extends Control
@onready var bg: Sprite2D = $BG
@onready var anim_saber: AnimatedSprite2D = $AnimSaber
@onready var anim_timer: Timer = $AnimTimer

var id: int = 0
var total_shots_left: int = 0

func _ready() -> void:
	SignalManager._on_dagger_thrown.connect(count_shots)
	set_timer()

func _process(_delta: float) -> void:
	if total_shots_left == id:
		bg.frame = 0
		anim_saber.visible = true
	elif total_shots_left > id:
		anim_saber.visible = true
		bg.frame = 1
	else:
		anim_saber.visible = false
		bg.frame = 1

func set_timer() -> void:
	anim_timer.wait_time = randf_range(3,7)
	anim_timer.start()

func play_anim() -> void:
	anim_timer.stop()
	anim_saber.play("shine")

func play_idle() -> void:
	anim_saber.play("idle")
	set_timer()

func count_shots(_value: Vector2) -> void: 
	total_shots_left-=1

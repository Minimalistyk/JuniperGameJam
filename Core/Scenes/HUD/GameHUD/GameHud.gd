extends Control

const SABER = preload("uid://c2iqauwhtg3gb")

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var p_label: Label = %PointsLabel
@onready var req_p_label: Label = %ReqPointsLabel

var total_shots: int = 0

func _ready() -> void:
	visible = true

func _process(_delta: float) -> void:
	p_label.text = str(GameManager.current_points)
	req_p_label.text = str(GameManager.points_needed)
	
	if GameManager.STATE == GameManager.GAME_STATES.GAME_OVER:
		visible = false

func start_game() -> void:
	total_shots = GameManager.total_shots
	

	for child in h_box_container.get_children():
		child.queue_free()
		
	for i in range(total_shots):
		var NS = SABER.instantiate()
		NS.id = i + 1 
		NS.total_shots_left = total_shots
		h_box_container.add_child(NS)


func update_daggers(current_shots_left: int) -> void:
	for child in h_box_container.get_children():
		child.total_shots_left = current_shots_left

extends Control

var total_shots: int = 0
var shots_left: int = 0
var points: int = 0
var points_needed: int = 0

const SABER = preload("uid://c2iqauwhtg3gb")

@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var p_label: Label = %PointsLabel
@onready var req_p_label: Label = %ReqPointsLabel

func _ready() -> void:
	total_shots = GameManager.total_shots
	points_needed = GameManager.points_needed
	SignalManager._on_target_hit.connect(update_score_from_target)

func _process(_delta: float) -> void:
	if GameManager.STATE == GameManager.GAME_STATES.GAME_OVER:
		visible= false

func start_game() -> void: #to nie jest _ready!
	p_label.text = str(points)
	req_p_label.text = str(points_needed)
	shots_left = total_shots
	for i in range(total_shots):
		var NS = SABER.instantiate()
		NS.id = i+1 #no bo tu sie zaczyna od 0 XD
		NS.total_shots_left = total_shots
		h_box_container.add_child(NS)

func update_score_from_target(points_earned: int) -> void:
	points += points_earned
	p_label.text = str(points)

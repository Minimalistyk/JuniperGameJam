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
	SignalManager._on_dagger_thrown.connect(update_p_label)

func start_game() -> void: #to nie jest _ready!
	p_label.text = str(points)
	req_p_label.text = str(points_needed)
	shots_left = total_shots
	for i in range(total_shots):
		var NS = SABER.instantiate()
		NS.id = i+1 #no bo tu sie zaczyna od 0 XD
		NS.total_shots_left = total_shots
		h_box_container.add_child(NS)
		

func update_p_label(value: Vector2) -> void: #na razie dzialam na sygnale ktory daje pozcyje strzalu
	points+=int(value.x)
	p_label.text = str(points)

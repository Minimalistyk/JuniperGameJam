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
	# ODŁĄCZAMY stary sygnał rzutu, a PODŁĄCZAMY nowy sygnał punktów z tarczy:
	SignalManager.on_target_hit.connect(update_score_from_target)

func start_game() -> void: #to nie jest _ready!
	p_label.text = str(points)
	req_p_label.text = str(points_needed)
	shots_left = total_shots
	for i in range(total_shots):
		var NS = SABER.instantiate()
		NS.id = i+1 #no bo tu sie zaczyna od 0 XD
		NS.total_shots_left = total_shots
		h_box_container.add_child(NS)

# NOWA FUNKCJA: Ta metoda dostaje już gotowe, pomnożone punkty z MainGame lub tarczy
func update_score_from_target(points_earned: int) -> void:
	points += points_earned
	p_label.text = str(points)

# Zostawiamy tę funkcję na wypadek, gdyby znajomy potrzebował jej do czegoś innego, 
# ale już nie dodaje ona pozycji X do punktów.
func update_p_label(value: Vector2) -> void:
	pass

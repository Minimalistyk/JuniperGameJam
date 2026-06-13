class_name DebugLabel
extends Label
@onready var root: Label = $"."
@export var object: Node

func _ready() -> void:
	pass 

func _process(_delta: float) -> void:
	update_debug_label()

func update_debug_label() -> void:
	if !object:
		return
	var debug_string: String = ""
	debug_string += "ID" + object.name + "\n"
	root.text = debug_string

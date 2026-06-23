class_name ObjectMaker
extends Node2D

const OBJECT_SCENES: Dictionary[Constants.OBJECT_TYPE, PackedScene] ={
	Constants.OBJECT_TYPE.DEBUG_POINT: preload("res://Core/Debug/DebugPoint/DebugPoint.tscn")
}

func _enter_tree() -> void:
	#kod łączący z signal managerem syganały do tworzenia obiektów
	SignalManager._on_create_object.connect(on_create_object)
	pass

func check_if_exists(object_type: Constants.OBJECT_TYPE) -> bool:
	if OBJECT_SCENES.has(object_type):
		return true
	else:
		printerr("Error ObjectMaker.gd, tried to create: " + str(object_type))
		return false


func on_create_object(pos: Vector2, object_type: Constants.OBJECT_TYPE, parent: Node = null) -> void:
	if !check_if_exists(object_type):
		return
	var new_object = OBJECT_SCENES[object_type].instantiate()
	
	if parent != null and is_instance_valid(parent):
		parent.add_child(new_object)
		new_object.global_position = pos
	else:
		call_deferred("add_child", new_object)
		new_object.global_position = pos

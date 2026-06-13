class_name ObjectMaker
extends Node2D

const OBJECT_SCENES: Dictionary[Constants.OBJECT_TYPE, PackedScene] ={
	#ciagnac przyklad duszka i kota:
	#Constants.OBJECT_TYPE.GHOST: preload("uid://xyz")
	#Constants.OBJECT_TYPE.CAT preload("uid://xyzt")
}

func _enter_tree() -> void:
	#kod łączący z signal managerem syganały do tworzenia obiektów
	SignalManager.on_create_object.connect(on_create_object)
	pass

func check_if_exists(object_type: Constants.OBJECT_TYPE) -> bool:
	if OBJECT_SCENES.has(object_type):
		return true
	else:
		printerr("Error ObjectMaker.gd, tried to create: " + str(object_type))
		return false


func on_create_object(pos: Vector2, object_type:  Constants.OBJECT_TYPE)-> void:
	if !check_if_exists(object_type):
		return
	var new_object =	OBJECT_SCENES[object_type].instantiate()
	new_object.global_position = pos
	call_deferred("add_child", new_object)

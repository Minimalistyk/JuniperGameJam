extends Node

signal on_create_object(pos, ob_type)

func emit_on_create_object(pos: Vector2, ob_type: Constants.OBJECT_TYPE) -> void:
	on_create_object.emit(pos, ob_type)

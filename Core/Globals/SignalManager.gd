extends Node

signal _on_create_object(pos, ob_type)

func emit_on_create_object(pos: Vector2, ob_type: Constants.OBJECT_TYPE) -> void:
	_on_create_object.emit(pos, ob_type)

signal _on_options_menu_show() 

func emit_on_options_menu_show() -> void:
	_on_options_menu_show.emit()

signal _on_options_menu_close() 

func emit_on_options_menu_close() -> void:
	_on_options_menu_close.emit()

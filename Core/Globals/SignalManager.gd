extends Node

signal _on_target_hit(points: int)

func emit_on_target_hit(points: int) -> void:
	_on_target_hit.emit(points)

signal _on_create_object(pos, ob_type, parent: Node)

func emit_on_create_object(pos: Vector2, ob_type: Constants.OBJECT_TYPE, parent: Node = null) -> void:
	_on_create_object.emit(pos, ob_type, parent)

signal _on_options_menu_show() 

func emit_on_options_menu_show() -> void:
	_on_options_menu_show.emit()

signal _on_options_menu_close() 

func emit_on_options_menu_close() -> void:
	_on_options_menu_close.emit()

signal _on_dagger_thrown(pos: Vector2)

func emit_on_dagger_thrown(pos: Vector2) -> void:
	_on_dagger_thrown.emit(pos)

signal _on_start_button_pressed()

func emit_on_start_button_pressed() -> void:
	_on_start_button_pressed.emit()

signal _on_quit_button_pressed()

func emit_on_quit_button_pressed() -> void:
	_on_quit_button_pressed.emit()

signal _on_credits_button_pressed()

func emit_on_credits_button_pressed() -> void:
	_on_credits_button_pressed.emit()

signal _on_options_button_pressed()

func emit_on_options_button_pressed() -> void:
	_on_options_button_pressed.emit()

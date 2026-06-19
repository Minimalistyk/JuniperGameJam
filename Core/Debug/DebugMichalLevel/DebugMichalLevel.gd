extends Node2D

func _ready() -> void:
	SignalManager._on_dagger_thrown.connect(markit)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		get_viewport().set_input_as_handled()
		get_tree().reload_current_scene()

func markit(pos: Vector2) -> void:
	SignalManager.emit_on_create_object(pos, Constants.OBJECT_TYPE.DEBUG_POINT)

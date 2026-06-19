class_name OptionsMenu
extends Control
@onready var options_menu_container: PanelContainer = %OptionsMenuContainer
var target_x: float

func _ready() -> void:
	SignalManager._on_options_menu_show.connect(on_options_menu_show)
	target_x = options_menu_container.position.x
	options_menu_container.position.x = 1280
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if visible:
			get_viewport().set_input_as_handled()
			back(0)

func on_options_menu_show() -> void:
	visible = true
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(options_menu_container, "position:x", target_x, 0.3).from(1280.0)

func back(play_sound: bool = 1) -> void:
	if play_sound:
		AudioManager.play_click()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(options_menu_container, "position:x", 1280.0, 0.2)
	tween.tween_callback(func(): visible = false)
	SignalManager.emit_on_options_menu_close()


func _on_button_mouse_entered() -> void:
	AudioManager.play_hover()

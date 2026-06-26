class_name Credits
extends Control

@onready var credits_menu_container: PanelContainer = %CreditsMenu
var target_x: float

func _ready() -> void:
	SignalManager.on_credits_menu_show.connect(on_credits_menu_show)
	target_x = credits_menu_container.position.x
	credits_menu_container.position.x = 1280
	visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if visible:
			get_viewport().set_input_as_handled()
			back(0)

func on_credits_menu_show() -> void:
	visible = true
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(credits_menu_container, "position:x", target_x, 0.3).from(1280.0)

func back(play_sound: bool = true) -> void:
	if play_sound:
		AudioManager.play_click()
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(credits_menu_container, "position:x", 1280.0, 0.2)
	tween.tween_callback(func(): visible = false)
	SignalManager.emit_on_credits_menu_close()

func _on_button_mouse_entered() -> void:
	AudioManager.play_hover()

func _on_back_button_pressed() -> void:
	back(true)

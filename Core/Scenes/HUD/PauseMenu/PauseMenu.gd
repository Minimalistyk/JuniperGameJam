class_name PauseMenu
extends Control
@onready var anim_player_pause_menu: AnimationPlayer = %AnimPlayerPauseMenu
@onready var pause_menu_container: PanelContainer = %PauseMenuContainer
@onready var black_rect: ColorRect = %BlackRect

var target_y: float
var options_up: bool

func _ready() -> void:
	SignalManager._on_options_menu_close.connect(on_options_menu_close)
	target_y = pause_menu_container.position.y
	resume()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if options_up:
			return
		if get_tree().paused:
			resume()
		else:
			show_menu()

func show_anim() -> void:
	pause_menu_container.visible = true
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(pause_menu_container, "position:y", target_y, 0.3).from(720.0)

func show_menu() -> void:
	PauseManager.set_pause(true)
	anim_player_pause_menu.play("blur")
	show_anim()

func resume_anim() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(pause_menu_container, "position:y", 720.0, 0.2)
	tween.tween_callback(func(): pause_menu_container.visible = false)

func resume() -> void:
	PauseManager.set_pause(false)
	anim_player_pause_menu.play_backwards("blur")
	resume_anim()

func open_options() -> void:
	options_up = true
	SignalManager.emit_on_options_menu_show()
	resume_anim()

func on_options_menu_close() -> void:
	options_up = false
	show_anim()

func quit() -> void:
	black_rect.visible = true
	anim_player_pause_menu.play("quit")

func close_app() -> void:
	get_tree().quit()

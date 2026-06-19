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
	hide_menu_logic()
	hide_menu_anim()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if options_up:
			return
		if get_tree().paused:
			hide_menu_logic()
			hide_menu_anim()
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

func hide_menu_anim() -> void:
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(pause_menu_container, "position:y", 720.0, 0.2)
	tween.tween_callback(func(): pause_menu_container.visible = false)

func hide_menu_logic() -> void:
	PauseManager.set_pause(false)
	anim_player_pause_menu.play_backwards("blur")

func resume() -> void:
	play_click()
	hide_menu_logic()
	hide_menu_anim()

func open_options() -> void:
	play_click()
	options_up = true
	SignalManager.emit_on_options_menu_show()
	hide_menu_anim()

func on_options_menu_close() -> void:
	options_up = false
	show_anim()

func quit() -> void:
	play_click()
	black_rect.visible = true
	anim_player_pause_menu.play("quit")

func close_app() -> void:
	get_tree().quit()
	
func play_click() -> void:
	AudioManager.play_click()

func _on_button_mouse_entered() -> void:
	AudioManager.play_hover()

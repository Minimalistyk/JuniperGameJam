extends Control

@onready var black_rect: ColorRect = %BlackRect
@onready var main_menu_anim_player: AnimationPlayer = $MainMenuAnimPlayer
@onready var camera_2d: Camera2D = %Camera2D
@onready var white_rect: ColorRect = $WhiteRect

func _ready():
	SignalManager._on_start_button_pressed.connect(change_to_main)
	SignalManager._on_options_button_pressed.connect(open_options)
	SignalManager._on_credits_button_pressed.connect(open_credits) 
	SignalManager._on_quit_button_pressed.connect(quit)
	camera_2d.global_position = get_viewport_rect().size /2

func _process(_delta):
	pass

func change_to_main() -> void:
	white_rect.visible = true
	main_menu_anim_player.play("StartGame")
	await get_tree().create_timer(0.5).timeout
	SceneManager.change_scene_to(Constants.SCENES.INTRO)

func open_options() -> void:
	SignalManager.emit_on_options_menu_show()

func open_credits() -> void:
	SignalManager.emit_on_credits_menu_show()
	
func quit() -> void:
	black_rect.visible = true
	main_menu_anim_player.play("quit")

func close_app() -> void:
	get_tree().quit()

extends Control
@onready var black_rect: ColorRect = %BlackRect
@onready var main_menu_anim_player: AnimationPlayer = $MainMenuAnimPlayer

func _ready():
	SignalManager._on_start_button_pressed.connect(change_to_main)
	SignalManager._on_options_button_pressed.connect(open_options)
	SignalManager._on_credits_button_pressed.connect(open_options)
	SignalManager._on_quit_button_pressed.connect(quit)

func _process(_delta):
	pass

func change_to_main() -> void:
	SceneManager.change_scene_to(Constants.SCENES.INTRO)

func open_options() -> void:
	SignalManager.emit_on_options_menu_show()

func quit() -> void:
	black_rect.visible = true
	main_menu_anim_player.play("quit")

func close_app() -> void:
	get_tree().quit()

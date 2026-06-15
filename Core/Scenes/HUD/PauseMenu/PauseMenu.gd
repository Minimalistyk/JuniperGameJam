extends Control
@onready var anim_player_pause_menu: AnimationPlayer = %AnimPlayerPauseMenu
@onready var pause_menu_container: PanelContainer = %PauseMenuContainer
@onready var black_rect: ColorRect = %BlackRect

var target_y: float

func _ready() -> void:
	target_y = pause_menu_container.position.y
	resume()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("Escape"):
		if get_tree().paused:
			resume()
		else:
			show_menu()

func show_menu() -> void:
	pause_menu_container.visible = true
	PauseManager.set_pause(true)
	anim_player_pause_menu.play("blur")
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(pause_menu_container, "position:y", target_y, 0.4).from(720.0)

func resume() -> void:
	PauseManager.set_pause(false)
	anim_player_pause_menu.play_backwards("blur")
	
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_IN)
	tween.tween_property(pause_menu_container, "position:y", 720.0, 0.3)
	tween.tween_callback(func(): pause_menu_container.visible = false)

func open_options() -> void:
	print(PauseManager.current_pause)
	pass	#powodzenia XD, przy okazji skasuj tą debudowa linijke
			#i prosze użyj tweena aby ustawienia wyskoczyly z dołu ekranu a menu pauzy sie schowalo w dół
			#mysle ze te tweeny wystaczy wtedy jebanac do osoncyh funkcji z parametrami co tweenujemy, skąd i dokąd :D

func quit() -> void:
	black_rect.visible = true
	anim_player_pause_menu.play("quit")

func close_app() -> void:
	get_tree().quit()

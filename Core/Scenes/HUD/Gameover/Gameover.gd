class_name gameover_hud
extends Control
@onready var texture_rect: TextureRect = $TextureRect
@onready var label_2: Label = $Label2
var time: float
var pos: Vector2

func _ready() -> void:
	pos = position
	position.y=720*2

func _physics_process(delta: float) -> void:
	time += delta
	var label_scale = (sin(time*2) + 1.25)
	label_2.scale = Vector2( label_scale,label_scale)
	texture_rect.rotation_degrees += 15 * delta

func show_gameover(points: int) -> void:
	label_2.text = str(points)
	var tween: Tween = create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position:y", pos.y, 0.3).from(1480)


func _on_start_button_pressed() -> void:
	#SceneManager.change_scene_to(Constants.SCENES.START_MENU)
	SceneManager.change_scene_to(Constants.SCENES.MAIN_GAME) # na razie restart 

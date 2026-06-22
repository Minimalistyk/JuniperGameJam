extends Control
@onready var bg_1: ColorRect = $BG1
@onready var texture_rect: TextureRect = $TextureRect
@onready var texture_rect_2: TextureRect = $TextureRect2
@onready var texture_rect_3: TextureRect = $TextureRect3
@onready var texture_rect_4: TextureRect = $TextureRect4
@onready var bg_2: ColorRect = $BG2
@onready var texture_rect_5: TextureRect = $TextureRect5
@onready var texture_rect_6: TextureRect = $TextureRect6
@onready var texture_rect_7: TextureRect = $TextureRect7
@onready var texture_rect_8: TextureRect = $TextureRect8
@onready var label: Label = $Label
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
#mozna do tego aucio stream playera dodaj jakas liste dzwiekow i na kazdym slidzie odrygwac jakis dzwiek konkrenty 

var slides: Array[Control] = []
var current_index: int = -1

func _ready() -> void:
	slides = [texture_rect, texture_rect_2, texture_rect_3, texture_rect_4, bg_2, texture_rect_5, texture_rect_6, texture_rect_7, texture_rect_8]
	for slide in slides:
		slide.modulate.a = 0.0
	show_next_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		show_next_slide()

func show_next_slide() -> void:
	current_index += 1
	if current_index >= slides.size():
		SceneManager.change_scene_to(Constants.SCENES.MAIN_GAME)
		return
	var current_slide = slides[current_index]
	var tween = create_tween()
	tween.tween_property(current_slide, "modulate:a", 1.0, 0.5)
	#jak chcemy jakis dziwek rgac to tutaj jest na to miejsce
	#tylko potrzeba jakis array dziekow i zeby skakal po nich aduiostramplayer tak samo jak skaczemu po slajdach
	
	

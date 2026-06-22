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
var slides: Array[Control] = []
var current_index: int = -1
#dzwieki 
const INTRO_1 = preload("uid://b6wfgk5c08ryo")
const INTRO_2 = preload("uid://dmjqteqds131r")
const INTRO_3 = preload("uid://ctysr4sapkrew")
const INTRO_4 = preload("uid://dwyv0p2u10ssy")
const INTRO_5 = preload("uid://2ycfvji3txdu")
const INTRO_6 = preload("uid://cuwt5kr6xyom3")
const INTRO_7 = preload("uid://cwv7hf4ucdvso")
const INTRO_8 = preload("uid://cdnh161yoks3l")
var sounds: Array[AudioStreamOggVorbis]

func _ready() -> void:
	sounds = [INTRO_1, INTRO_2, INTRO_3, INTRO_4, INTRO_5, INTRO_6, INTRO_7, INTRO_8]
	slides = [texture_rect, texture_rect_2, texture_rect_3, texture_rect_4, texture_rect_5, texture_rect_6, texture_rect_7, texture_rect_8]
	for slide in slides:
		slide.modulate.a = 0.0
	bg_2.modulate.a = 0.0
	show_next_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		show_next_slide()

func show_next_slide() -> void:
	current_index += 1
	if current_index >= slides.size():
		SceneManager.change_scene_to(Constants.SCENES.MAIN_GAME)
		return
	
	if current_index == 4:
		var _tween = create_tween()
		_tween.tween_property(bg_2, "modulate:a", 1.0, 0.5)
	
	var current_slide = slides[current_index]
	var current_sound = sounds[current_index]
	audio_stream_player.stream = current_sound
	audio_stream_player.play()
	var tween = create_tween()
	tween.tween_property(current_slide, "modulate:a", 1.0, 0.5)

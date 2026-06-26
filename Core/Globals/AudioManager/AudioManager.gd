extends Node

var hover_sound: AudioStreamPlayer
var click_sound: AudioStreamPlayer
var target_sound: AudioStreamPlayer
var win_sound: AudioStreamPlayer
var music: AudioStreamPlayer
var crack: AudioStreamPlayer

var current_music_key: String = "" # Pamięć ostatniego utworu

var music_tracks: Dictionary = {
	"PIRATE_1" : preload("uid://b2amdcvucxul7"),
	"PIRATE_2" : preload("uid://b2kr6pygja1xu"),
	"PIRATE_3" : preload("uid://bd6di58ht4jtv"),
	"PIRATE_7" : preload("uid://6ga10ige8q7s"),
}

var hud_tracks: Dictionary = {
	"MENU_6" : preload("uid://b0bcc0ng1job4"), #click
	"MENU_7" : preload("uid://dxqi4cw8eq8l8"), #hover
	"MENU_24" : preload("uid://qwddk246knm2"),
	"WOOD_CHOP": preload("uid://cr3j884cli1hk"),
	"CRACK" : preload("uid://djyujbe5yllw0")
}

var sfx_tracks: Dictionary = {
	"WOOD_CHOP": preload("uid://cr3j884cli1hk"),
	"WIN": preload("uid://badk5gc83o486"),
	"TICK": preload("uid://beqjky0fgxgdo"), #ten dziwek jak kolo sie kreci tyk tyk tyk tyk
	"FAIL": preload("uid://dsh2riokq6w7u"),
	"BREAK": preload("uid://2mc7u8altfxw")
	
}

func _ready() -> void:
	hover_sound = create_player("HUD", hud_tracks["MENU_7"])
	click_sound = create_player("HUD", hud_tracks["WOOD_CHOP"])
	target_sound = create_player("SFX", sfx_tracks["WOOD_CHOP"])
	crack = create_player("HUD", hud_tracks["CRACK"]) 
	music = create_player("Music", null)
	music.finished.connect(_on_music_finished)
	
	play_random_music()

func create_player(bus_name: String, stream: AudioStream = null) -> AudioStreamPlayer:
	var ASP = AudioStreamPlayer.new()
	add_child(ASP)
	ASP.stream = stream
	ASP.bus = bus_name
	return ASP

func play_click() -> void:
	click_sound.pitch_scale = randf_range(0.8, 1.2)
	click_sound.play()

func play_target_sound() -> void:
	target_sound.pitch_scale = randf_range(0.8, 1.2)
	target_sound.play()

func play_hover() -> void:
	hover_sound.pitch_scale = randf_range(0.8, 1.2)
	hover_sound.play()

func play_crack_sound() -> void:
	crack.pitch_scale = randf_range(0.8, 1.2)
	crack.play()

func play_sfx(sfx_name: String, randomize_pitch: bool = false) -> void:
	if !sfx_tracks.has(sfx_name):
		return
		
	var sfx_player = AudioStreamPlayer.new()
	add_child(sfx_player)
	
	sfx_player.stream = sfx_tracks[sfx_name]
	sfx_player.bus = "SFX"
	
	if randomize_pitch:
		sfx_player.pitch_scale = randf_range(0.8, 1.2)
		
	sfx_player.play()
	sfx_player.finished.connect(sfx_player.queue_free)

func play_random_music() -> void:
	var available_keys = music_tracks.keys()

	if current_music_key != "":
		available_keys.erase(current_music_key)
		
	var random_key = available_keys.pick_random()
	current_music_key = random_key
	
	music.stream = music_tracks[random_key]
	music.play()

func _on_music_finished() -> void:
	play_random_music()

func change_music(music_name: String, transition_duration: float) -> void:
	if !music_tracks.has(music_name):
		push_error("Brak utworu: " + music_name)
		return
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -60.0, transition_duration / 2.0)
	await tween.finished
	
	current_music_key = music_name 
	music.stream = music_tracks[music_name]
	music.play()
	
	var tween_in = create_tween()
	tween_in.tween_property(music, "volume_db", 0.0, transition_duration / 2.0)

func play_music() -> void:
	music.play()

func toggle_music(value: bool) -> void:
	music.playing = value

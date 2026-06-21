extends Node
var hover_sound: AudioStreamPlayer
var click_sound: AudioStreamPlayer
var music: AudioStreamPlayer

var music_tracks: Dictionary = {
	#"muzyka1": preload("res://xyz")
}
var hud_tracks: Dictionary = {
	"MENU_6" = preload("uid://1rghy521vw11"), #click
	"MENU_7" = preload("uid://ca2ehqmrrwvwr"), #hover
	"MENU_24" = preload("uid://qwddk246knm2"),
	"WOOD_CHOP"= preload("uid://cr3j884cli1hk")
}

var sfx_tracks: Dictionary = {
	#"muzyka1": preload("res://xyz")
}

func _ready() -> void:
	hover_sound = create_player("HUD", hud_tracks["MENU_7"])
	click_sound = create_player("HUD", hud_tracks["WOOD_CHOP"])
	music = create_player("Music",null) #cos sie wymysli

func create_player(bus_name: String, stream: AudioStream = null) -> AudioStreamPlayer:
	var ASP = AudioStreamPlayer.new()
	add_child(ASP)
	ASP.stream = stream
	ASP.bus = bus_name
	return ASP

func play_click() -> void:
	click_sound.pitch_scale = randf_range(0.8, 1.2)
	click_sound.play()

func play_hover() -> void:
	hover_sound.pitch_scale = randf_range(0.8, 1.2)
	hover_sound.play()

func change_music(music_name: String, transition_duration: float) -> void:
	if !music_tracks.has(music_name):
		push_error("Brak utworu: " + music_name)
		return
	var tween = create_tween()
	tween.tween_property(music, "volume_db", -60.0, transition_duration / 2.0)
	await tween.finished
	
	music.stream = music_tracks[music_name]
	play_music()
	
	var tween_in = create_tween()
	tween_in.tween_property(music, "volume_db", 0.0, transition_duration / 2.0)

func play_music() -> void:
	music.play()

func toggle_music(value: bool) -> void:
	music.playing = value

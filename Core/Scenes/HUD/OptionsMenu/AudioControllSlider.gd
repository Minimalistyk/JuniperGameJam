class_name AudioControllSlider
extends HSlider

@export var audio_bus_name: String
var audio_bus_id: int

func _ready() -> void:
	audio_bus_id = AudioServer.get_bus_index(audio_bus_name)
	var current_db = AudioServer.get_bus_volume_db(audio_bus_id)
	value = db_to_linear(current_db)

func _on_value_changed(s_value: float) -> void:
	# 4. Kiedy gracz rusza suwakiem, zamieniamy na decybele i wysyłamy do silnika
	var db = linear_to_db(s_value)
	AudioServer.set_bus_volume_db(audio_bus_id, db)

extends Node

signal _toggle_pause(status: bool)
var current_pause: int = 0

func _enter_tree() -> void:
	current_pause = Constants.PAUSE_STATES.PLAYING #tak mi sie wydaje ze nigdy przy inicjalizacji nie bedzie domyślnie pauzy

func check_pause() -> int: #albo mozna uzyc PauseManager.current_pause XD
	return current_pause

func toggle_pause() -> void: #toggle twardej pauzy
	if get_tree().paused:
		get_tree().paused = false
		current_pause = Constants.PAUSE_STATES.PLAYING
	else:
		get_tree().paused = true
		current_pause = Constants.PAUSE_STATES.HARD_PAUSE
	_toggle_pause.emit(get_tree().paused)
	

func set_pause(status: bool) -> void: #twada pauza
	if status:
		current_pause = Constants.PAUSE_STATES.HARD_PAUSE
	else:
		current_pause = Constants.PAUSE_STATES.PLAYING
	get_tree().paused = status
	_toggle_pause.emit(status)

#jesli bedzie potrzeba tu mozemy dodac twarde puazy, lekkie pauzy itd
#np twarda pauza: w ustawianich.
#np lekka pauza: cutscenka i gracz nie ma możliwości inputu
# potrzebne beda sygnały, te od pauzy wyjątkowo w tym skrypcie nie w SignalManagerze!

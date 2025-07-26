extends HSlider


@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_on_value_changed)
	value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))

func _on_value_changed(sliderValue: float) -> void:
	AudioServer.set_bus_volume_db(bus_index,linear_to_db(sliderValue))
	if bus_index == 0:
		GlobalVariables.gMasterVolume = float (sliderValue)
	elif bus_index == 1:
		GlobalVariables.gMusicVolume = float (sliderValue)
	elif bus_index == 2:
		GlobalVariables.gSfxVolume = float (sliderValue)

func _set_master() -> void:
	AudioServer.set_bus_volume_db(0,linear_to_db(GlobalVariables.gMasterVolume))
	
func _set_sfx() -> void:
	AudioServer.set_bus_volume_db(1,linear_to_db(GlobalVariables.gMusicVolume))
	
func _set_music() -> void:
	AudioServer.set_bus_volume_db(2,linear_to_db(GlobalVariables.gSfxVolume))

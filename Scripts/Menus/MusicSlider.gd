extends HSlider

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))


func ChangeValue(_value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(_value))

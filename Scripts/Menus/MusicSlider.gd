extends HSlider

@export var channel: String

func _ready():
	value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index(channel)))


func ChangeValue(_value:float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(channel), linear_to_db(_value))

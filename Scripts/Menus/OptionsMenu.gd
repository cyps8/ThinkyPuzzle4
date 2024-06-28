extends CanvasLayer

class_name OptionsMenu

func BackButton():
	SceneManager.ins.CloseOptionsMenu()

func _process(_dt):
	if (Input.is_action_just_pressed("Pause")):
		SceneManager.ins.CloseOptionsMenu()
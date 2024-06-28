extends CanvasLayer

class_name PauseMenu

func BackButton():
	GameManager.ins.TogglePause()

func OptionsButton():
	SceneManager.ins.OpenOptionsMenu()

func MenuButton():
	SceneManager.ins.ChangeScene(SceneManager.Scene.MENU)
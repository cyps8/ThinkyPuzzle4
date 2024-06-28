extends Node

class_name SceneManager
static var ins: SceneManager

@export var gameScene: PackedScene
@export var menuScene: PackedScene

enum Scene{
	MENU,
	GAME
}

var optionsRef: OptionsMenu
var optionsOpen: bool = false

var loadingRef: CanvasLayer

var currentSceneNode: Node = null

var currentScene: Scene = Scene.GAME

func _ready():
	optionsRef = get_node("OptionsMenu")
	remove_child(optionsRef)

	loadingRef = get_node("LoadScreen")
	remove_child(loadingRef)

	ins = self
	ChangeScene(Scene.MENU)

func ChangeScene(newScene: Scene):
	if currentScene == newScene:
		return

	if currentSceneNode != null:
		currentSceneNode.queue_free()

	if newScene == Scene.MENU:
		currentSceneNode = menuScene.instantiate()
	elif newScene == Scene.GAME:
		currentSceneNode = gameScene.instantiate()
		
	add_child(currentSceneNode)

	currentScene = newScene

func OpenOptionsMenu():
	add_child(optionsRef)
	optionsOpen = true

func CloseOptionsMenu():
	remove_child(optionsRef)
	optionsOpen = false

func ShowLoadingScreen():
	add_child(loadingRef)

func HideLoadingScreen():
	remove_child(loadingRef)

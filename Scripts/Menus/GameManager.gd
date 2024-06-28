extends Node2D

class_name GameManager

static var ins: GameManager

var pauseRef: CanvasLayer

func _init():
	ins = self

func _ready():
	pauseRef = get_node("Pause")
	pauseRef.visible = true
	remove_child(pauseRef)

func _process(_dt):
	if Input.is_action_just_pressed("Pause"):
		TogglePause()

func TogglePause():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		add_child(pauseRef)
	else:
		remove_child(pauseRef)
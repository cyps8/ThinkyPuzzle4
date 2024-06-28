extends Area2D

class_name Player

func _process(_dt):
    if Input.is_action_just_pressed("Up"):
        position.y -= 128
    elif Input.is_action_just_pressed("Down"):
        position.y += 128
    elif Input.is_action_just_pressed("LUp"):
        position.y -= 64
        position.x -= 96
    elif Input.is_action_just_pressed("RUp"):
        position.y -= 64
        position.x += 96
    elif Input.is_action_just_pressed("LDown"):
        position.y += 64
        position.x -= 96
    elif Input.is_action_just_pressed("RDown"):
        position.y += 64
        position.x += 96

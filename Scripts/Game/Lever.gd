extends Area2D

class_name Lever

@export var targetSection: Node2D

@export var movement: Vector2

var moved: bool = false

func _ready():
	Player.ins.Reset.connect(ResetRN)

func ResetRN():
	if moved:
		targetSection.position -= movement
		moved = false

func Pressed():
	var tween: Tween = create_tween().set_parallel(true)
	AudioPlayer.ins.PlaySound(1, AudioPlayer.SoundType.SFX, 1, randf() * 0.2 + 0.9)
	if !moved:
		tween.tween_property(targetSection, "position", targetSection.position + movement, 0.95).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	else:
		tween.tween_property(targetSection, "position", targetSection.position - movement, 0.95).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if get_parent() == targetSection:
		if !moved:
			tween.tween_property(Player.ins, "position", Player.ins.position + movement, 0.95).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		else:
			tween.tween_property(Player.ins, "position", Player.ins.position - movement, 0.95).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	moved = !moved

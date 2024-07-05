extends Node2D

class_name Zipline

var line: Line2D
var end1: Area2D
var end2: Area2D

@export var end1Section: Node2D
@export var end2Section: Node2D

func _ready():
	line = $Line
	end1 = $End1
	end1.zipline = self
	if end1Section:
		remove_child(end1)
		end1Section.add_child(end1)
	end2 = $End2
	end2.zipline = self
	if end2Section:
		remove_child(end2)
		end2Section.add_child(end2)

func _process(_dt):
	line.points[0] = end1.global_position
	line.points[1] = end2.global_position

func ZipFromEnd(end: Area2D) -> Vector2:
	var otherEnd: Area2D
	if end == end1:
		otherEnd = end2
	else:
		otherEnd = end1

	if end.global_position.y > otherEnd.global_position.y:
		return end.global_position
	else:
		return otherEnd.global_position

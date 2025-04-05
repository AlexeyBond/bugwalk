extends Node

class_name FootGroup

@export var feet: Array[Foot]

func wants_move() -> bool:
	for foot in feet:
		if foot.wants_move():
			return true
	return false

func needs_move() -> bool:
	for foot in feet:
		if foot.needs_move():
			return true
	return false

func is_moving() -> bool:
	for foot in feet:
		if foot.is_moving():
			return true
	return false

func do_move():
	for foot in feet:
		if foot.wants_move():
			foot.do_move()

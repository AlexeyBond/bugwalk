extends Node

class_name FootBrain

@export var groups: Array[FootGroup]

var _current_group: int = 0

func _process(_delta: float) -> void:
	if groups[_current_group].is_moving():
		return
	
	for j in range(len(groups)):
		var x := (_current_group + j) % len(groups)
		if groups[x].needs_move():
			groups[x].do_move()
			_current_group = x
			return

	_current_group = (_current_group + 1) % len(groups)

	for j in range(len(groups)):
		var x := (_current_group + j) % len(groups)
		if groups[x].wants_move():
			groups[x].do_move()
			_current_group = x
			return


func needs_move() -> bool:
	for group in groups:
		if group.needs_move():
			return true

	return false

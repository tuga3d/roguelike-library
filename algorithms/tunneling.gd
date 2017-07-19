extends Node

var width = 31
var height = 18
var level = []


func _init():
	set_meta('s_seed', 'test')
	set_meta('i_max_room_size', 15)
	set_meta('i_min_room_size', 6)
	set_meta('i_max_rooms', 6)


func generate_level(width, height):
	seed(hash(get_meta('s_seed')))
	initialize_level()

	return level


func initialize_level():
	level.clear()

	for x in range(width):
		var _temp = []
		for y in range(height):
			_temp.append(1)
		level.append(_temp)

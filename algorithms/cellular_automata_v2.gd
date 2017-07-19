extends Node

var width = 31
var height = 18
var level = []


func _init():
	set_meta('s_seed', 'test')
	set_meta('f_wall_probability', 0.5)
	set_meta('i_iterations', 30000)
	set_meta('i_neighbors', 4)


func generate_level(width, height):
	seed(hash(get_meta('s_seed')))
	initialize_level()
	random_fill_level()
	create_caves()

	return level


func initialize_level():
	level.clear()

	for x in range(width):
		var _temp = []
		for y in range(height):
			_temp.append(1)
		level.append(_temp)


func random_fill_level():
	for x in range(width):
		for y in range(height):
			if randf() >= get_meta("f_wall_probability"):
				level[x][y] = 0


func create_caves():
	for i in range (0, get_meta("i_iterations")):
		var x = randi() % (width - 3) + 1
		var y = randi() % (height - 3) + 1
		if getAdjacentWalls(x, y) > get_meta("i_neighbors"):
			level[x][y] = 1
		elif getAdjacentWalls(x, y) < get_meta("i_neighbors"):
			level[x][y] = 0


func getAdjacentWalls(x, y):
	var wallCounter = 0
	for neighbor_x in range(x - 1, x + 2):
		for neighbor_y in range(y - 1, y + 2):
			if (level[neighbor_x][neighbor_y] == 1):
				if (neighbor_x != x) or (neighbor_y != y):
					wallCounter += 1
	return wallCounter

extends Node

var width = 31
var height = 18
var level = []


func _init():
	set_meta('s_seed', 'test')
	set_meta('i_room_max_size', 7)
	set_meta('i_room_min_size', 3)
	set_meta('i_max_rooms', 6)


func _randi_range(min_num, max_num):
	return randi() % (max_num - min_num + 1) + min_num


func generate_level():
	if get_meta('s_seed') == '-1':
		randomize()
	else:
		seed(hash(get_meta('s_seed')))
	initialize_level()
	generate_rooms()
	return level


func initialize_level():
	level.clear()

	for x in range(width):
		var _temp = []
		for y in range(height):
			_temp.append(1)
		level.append(_temp)


func generate_rooms():
	var rooms = []
	var num_rooms = 0
	for r in range(get_meta('i_max_rooms')):
		var w = _randi_range(get_meta('i_room_min_size'), get_meta('i_room_max_size'))
		var h = _randi_range(get_meta('i_room_min_size'), get_meta('i_room_max_size'))
		var x = _randi_range(0, width - w - 1)
		var y = _randi_range(0, height - h - 1)

		var new_room = Rect2(x, y, w, h)
		var failed = false

		for other_room in rooms:
			if new_room.intersects(other_room):
				failed = true
				break

		if not failed:
			create_room(new_room)
			var new_x = new_room.position.x + new_room.size.x / 2
			var new_y = new_room.position.y + new_room.size.y / 2
			if num_rooms != 0:
				var prev_room = rooms[num_rooms - 1]
				var prev_x = prev_room.position.x + prev_room.size.x / 2
				var prev_y = prev_room.position.y + prev_room.size.y / 2
				if _randi_range(0, 1) == 1:
					createHorTunnel(prev_x, new_x, prev_y)
					createVirTunnel(prev_y, new_y, new_x)

				else:
					createVirTunnel(prev_y, new_y, prev_x)
					createHorTunnel(prev_x, new_x, new_y)
			rooms.append(new_room)
			num_rooms += 1


func create_room(room):
	print('create room: ', room)
	for x in range(room.position.x, room.position.x + room.size.x):
		for y in range(room.position.y, room.position.y + room.size.y):
			level[x][y] = 0


func createHorTunnel(x1, x2, y):
	for x in range(min(x1, x2), max(x1, x2) + 1):
		self.level[x][y] = 0


func createVirTunnel(y1, y2, x):
	for y in range(min(y1, y2),max(y1, y2) + 1):
		self.level[x][y] = 0

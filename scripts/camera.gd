extends Camera2D

var can_move = false

func _input(event):
	if (event is InputEventMouseButton):
		if (event.is_pressed()):
			if (event.get_button_index() == BUTTON_WHEEL_UP):
				self.zoom -= Vector2(.1 ,.1)
			if (event.get_button_index() == BUTTON_WHEEL_DOWN):
				self.zoom += Vector2(.1 ,.1)
			if (event.get_button_index() == BUTTON_LEFT):
				can_move = true
		else:
			can_move = false
	if (event is InputEventMouseMotion and can_move):
		self.offset -= event.get_relative() * self.zoom
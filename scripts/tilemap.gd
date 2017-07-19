extends TileMap


func draw_level(width, height, level):
	self.clear()

	for x in range(width):
		for y in range(height):
			self.set_cell(x, y, level[x][y])

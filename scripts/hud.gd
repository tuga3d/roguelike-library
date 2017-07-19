extends CanvasLayer

export (NodePath) var tilemap_path

onready var algorithm = get_node("container/algorithm")
onready var generate = get_node("container/generate")
onready var properties_node = get_node("container/properties")

var level_generator
var properties_dictionary = {}
var level_generator_path = "res://algorithms"


func _ready():
	algorithm.connect("item_selected", self, "_on_item_selected")
	generate.connect("pressed", self, "_on_generate_pressed")
	populate_algorithms()
	populate_properties(algorithm.get_selected())


func populate_algorithms():
	var file_list = []
	var dir = Directory.new()
	dir.open(level_generator_path)

	dir.list_dir_begin()
	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with(".") and file.ends_with(".gd"):
			file_list.append(file)
	dir.list_dir_end()

	for id in range(file_list.size()):
		algorithm.add_item(file_list[id], id)


func populate_properties(id):
	var path = "%s/%s" % [level_generator_path, algorithm.get_item_text(id)]
	level_generator = load(path).new()

	# research how to get properties i set in scripts so i can remove
	# the set/get meta hack.
	# print(level_generator.get_property_list())

	for property in level_generator.get_meta_list():
		var label = Label.new()
		var line_edit = LineEdit.new()
		line_edit.connect("text_changed", self, "_on_line_edit_text_changed", [property])
		label.text = property
		line_edit.text = str(level_generator.get_meta(property))
		properties_node.add_child(label)
		properties_node.add_child(line_edit)

		line_edit.connect("text_changed", self, "_on_text_changed", [property])
		properties_dictionary[property] = level_generator.get_meta(property)


func _on_item_selected(id):
	for child in properties_node.get_children():
		child.queue_free()
	populate_properties(id)


func _on_generate_pressed():
	for x in properties_dictionary:
		level_generator.set_meta(x, properties_dictionary[x])
	var width = get_node("container/map_width").text
	var height = get_node("container/map_height").text
	level_generator.width = int(width)
	level_generator.height = int(height)

	var timing = OS.get_ticks_msec()
	var level = level_generator.generate_level()
	print('Generation took: ', OS.get_ticks_msec() - timing, ' msec')

	get_node(tilemap_path).draw_level(width, height, level)

func _on_text_changed(text, property):
	if property.begins_with('i'):
		properties_dictionary[property] = int(text)
	elif property.begins_with('f'):
		properties_dictionary[property] = float(text)
	else:
		properties_dictionary[property] = text
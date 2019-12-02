extends Node2D

onready var room = preload("res://Scenery/Room.tscn")
var offset_x = Vector2(1.0, 0.0)
var offset_y = Vector2(0.0, 1.0)
var tilesize = 16.0;
var min_gap = 3.0;
var last_directions = []

func _ready():
	gen_level(8) 

func gen_level(number_of_rooms):
	var last_room;
	var last_dir =  {"x":0, "y": 0}
	for i in range(0, number_of_rooms ):
		var room_instance = room.instance()
		self.add_child(room_instance)
		if i == 0:
			room_instance.generate(Vector2(0.0, 0.0), Vector2())
			last_room = room_instance
		else:
			var offset_dir = get_next_direction(last_directions)
			var corners = last_room.get_corners()
			var offset = Vector2()

			offset.x = (ceil(last_room.size.x / 2.0) + ceil(room_instance.size.x / 2.0) + min_gap) * tilesize * offset_dir["x"]
			offset.y = (ceil(last_room.size.y / 2.0) + ceil(room_instance.size.y / 2.0) + min_gap) * tilesize * offset_dir["y"]
			
			room_instance.generate(Vector2(0.0, 0.0), Vector2())
			room_instance.make_doors(offset_dir)
			room_instance.set_position(last_room.get_position() +  corners["mid"] * tilesize + offset)
			
			last_room = room_instance
			last_directions.append(offset_dir)

func get_next_direction(last_dir):
	var offset;
	var dir = {"x":0, "y": 0}
	
	if rand_range(0, 1) > 0.5:
		offset = offset_x
		dir["x"] = 1
	else:
		offset = offset_y
		dir["y"] = 1
	
	if rand_range(0, 1) > 0.5:
		dir["x"] *= -1
		dir["y"] *= -1
	
	var templist = []
	for i in range(-1, -4):
		templist.append(last_dir[i])
		
	if not dir["x"] in templist:
		dir["x"] *= -1 
	if not dir["y"] in templist:
		dir["y"] *= -1 

	return dir
	
#func corridor(point_a, point_b):
#	var vec_diff = point_b - point_a
#
#	for x in range(0, vec_diff.x + 1 * sign(vec_diff.x),  sign(vec_diff.x)):
#		for i in range(0,2):
#			tilemap.set_cell(point_a.x + x, point_a.y + i, 5)
#
#	for y in range(0, vec_diff.y + 1, sign(vec_diff.y)):
#		tilemap.set_cell(point_a.x, point_a.y + y, 5)

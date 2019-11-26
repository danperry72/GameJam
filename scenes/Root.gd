extends Node2D

onready var GoblinNode = preload("res://Objects/Characters/Goblin/Goblin.tscn")
onready var tilemap = get_node("Background/TopDown")
var COLOUR = 0.0;
var spawn_time = 600;
var t = 0
var roomlist = []
onready var player = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	spawn_enemies()
	generate_level()
	place_player()
	
func place_player():
	var rand_room_n = randi()%len(roomlist)
	var coords = room_middle( roomlist[rand_room_n]  )
	var world_coords = coords * 16.0
	player.global_position = world_coords

func room_middle(room):
	return Vector2(room[round(len(room) / 2.0)][0], room[round(len(room) / 2.0)][1])

func spawn_enemies():
	for i in range(0,3): # Replace with function body.
		var instance = GoblinNode.instance()
		instance.set_position(Vector2(300.0, 350.0 - 20.0 * i))
		instance.aggro_range = 199.0
		self.add_child(instance)
		instance.set_colour( round(rand_range(1.0,3.0)) )
		
func set_colour(colour):
	COLOUR = colour

func generate_level():
	var id = 12
	var offset = Vector2(0.0,0.0)
	var room_pos = Vector2(0.0,0.0)
	var offset_mag = 30
	var offshoots = 1
	for i in range(0,8):
		if i != 0:
			var last_room_pos = Vector2(roomlist[i - 1][0][0],roomlist[i - 1][0][1])

			if rand_range(0,1) > 0.6:
				offshoots = floor(rand_range(0,4))

			for i in range(0, offshoots):
				if rand_range(0,1) > 0.5:
					offset = Vector2(offset_mag, 0.0)
				else:
					offset = Vector2(0.0, offset_mag)
				roomlist.append(room( last_room_pos + offset, round(rand_range(5,25)),  round(rand_range(5,25))))
		else:
			roomlist.append(room( room_pos, round(rand_range(5,25)),  round(rand_range(5,25))))
			
			
		if i != 0:
			var point_a = room_middle( roomlist[i] )
			var point_b = room_middle( roomlist[i - 1] )
			corridor( Vector2(point_a[0], point_a[1]),  Vector2(point_b[0], point_b[1])  )

	for i in tilemap.get_used_cells():
		var x = i[0]
		var y = i[1]
		var left = tilemap.get_cell(x - 1, y)
		var right = tilemap.get_cell(x + 1, y)
		var above = tilemap.get_cell(x, y - 1)
		var below = tilemap.get_cell(x, y + 1)

		if above == -1:
			tilemap.set_cell(x, y - 1 , 30)
		if below == -1:
			tilemap.set_cell(x, y + 1, 30)
		if left == -1:
			tilemap.set_cell(x - 1, y, 30)
		if right == -1:
			tilemap.set_cell(x + 1, y, 30)

func room(pos,size_x,size_y):
	var room_cells = []
	var x = pos.x
	var y = pos.y
	for i in range(x, x + size_x + 1):
		for j in range(y, y + size_y + 1):
			room_cells.append([i, j])
			tilemap.set_cell(i, j, 12)
	return room_cells
	
func corridor(point_a, point_b):
	var vec_diff = point_b - point_a
	
	for x in range(0, vec_diff.x + 1 * sign(vec_diff.x),  sign(vec_diff.x)):
		for i in range(0,2):
			tilemap.set_cell(point_a.x + x, point_a.y + i, 12)
		
	for y in range(0, vec_diff.y + 1, sign(vec_diff.y)):
		tilemap.set_cell(point_a.x, point_a.y + y, 12)

func get_colour():
	return COLOUR 

func _physics_process(delta):
	if t >= spawn_time:
		#spawn_enemies()
		t = 0
		spawn_time = rand_range(50, 200)
	t += 1

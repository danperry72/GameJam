extends Node2D

onready var GoblinNode = preload("res://Objects/Characters/Goblin/Goblin.tscn")
onready var tilemap = get_node("Background/TopDown")
var COLOUR = 0.0;
var spawn_time = 600;
var t = 0

onready var player = get_node("Player")
# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemies()
	generate_level()
		
func spawn_enemies():
	for i in range(0,3): # Replace with function body.
		var instance = GoblinNode.instance()
		instance.set_position(Vector2(300.0, 350.0 - 20.0 * i))
		instance.aggro_range = 199.0
		self.add_child(instance)
		instance.set_colour( round(rand_range(1.0,3.0)) )
		
func set_colour(colour):
	COLOUR = colour

func get_chances(x,y):
	var l_wall_threshold = 1
	var r_wall_threshold = 50
	var ceil_threshold = 1
	var floor_threshold = 50
	var chance = 0
	if x <= l_wall_threshold or x >= r_wall_threshold or y >= floor_threshold or y <= ceil_threshold:
		chance = 1.0
		return chance
	else:
		var left = tilemap.get_cell(x + 1, y)
		var right = tilemap.get_cell(x - 1, y)
		var above = tilemap.get_cell(x,y-1)
		var below = tilemap.get_cell(x,y+1)
		if left != -1 or right != -1 or above != -1 or below != -1:
			chance = 0.7
			return chance
	return chance

func generate_level():
	var id = 12
	for i in range(0,8):
		room(i * 30, 0.0, randi()%25+5, randi()%25+5)

	for i in tilemap.get_used_cells():
		var x = i[0]
		var y = i[1]
		var left = tilemap.get_cell(x - 1, y)
		var right = tilemap.get_cell(x + 1, y)
		var above = tilemap.get_cell(x, y - 1)
		var below = tilemap.get_cell(x, y + 1)

		if above == -1:
			tilemap.set_cell(x, y - 1 , 27)
		if below == -1:
			tilemap.set_cell(x, y + 1, 43)
		if left == -1:
			tilemap.set_cell(x - 1, y, 37)
		if right == -1:
			tilemap.set_cell(x + 1, y, 34)

func room(x,y,size_x,size_y):
	for i in range(x, x + size_x):
		for j in range(y, y + size_y):
			tilemap.set_cell(i, j, 12)
				

func get_colour():
	return COLOUR 

func _physics_process(delta):
	if t >= spawn_time:
		#spawn_enemies()
		t = 0
		spawn_time = rand_range(50, 200)
	t += 1

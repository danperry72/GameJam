extends Node2D

var max_x = 20; var max_y = 20
var min_x = 5; var min_y = 5 
var size = Vector2()
var corners = {"topright":Vector2(), "topleft":Vector2(), 
			   "bottomright":Vector2(), "bottomleft":Vector2(), 
			   "mid":Vector2(), "midleft": Vector2(), "midright": Vector2(),
			   "midtop":Vector2(), "midbottom": Vector2() }
var pos = Vector2()
var COLOUR = 2.0;
var tilesize = 16.0
onready var tilemap = get_node("TileMap")
const room_shader = preload("res://shaders/new_shader.shader")

func _ready():
	randomize()
	size = Vector2(ceil(rand_range(min_x, max_x)), ceil(rand_range(min_y, max_y)))

	var mid_x = round(size.x / 2.0)
	var mid_y = round(size.y / 2.0)
	
	corners["mid"] = Vector2(mid_x, mid_y)
	corners["topright"] = Vector2(size.x, 0)
	corners["topleft"] = Vector2(0,0)
	corners["bottomright"] = Vector2(size.x, size.y)
	corners["bottomleft"] = Vector2(0, size.y)
	corners["midtop"] = Vector2(floor(size.x / 2.0), 0.0)
	corners["midbottom"] = Vector2(floor(size.x / 2.0), size.y)
	corners["midleft"] = Vector2(0.0, floor(size.y / 2.0))
	corners["midright"] = Vector2(size.x, floor(size.y / 2.0))
	
func get_corners():
	return corners

func set_position(p):
	global_position = p - Vector2(floor(size.x / 2), floor(size.y / 2)) * tilesize

func generate_shaders():
	var mat = ShaderMaterial.new()
	mat.set_shader(room_shader)
	self.set_material(mat)
	self.set_colour(COLOUR)
	
func generate(pos, offset):
	generate_floor(pos, offset)

func generate_floor(pos, offset):
	var id = 5
	for i in range(0, size.x + 1):
		for j in range(0, size.y + 1):
			tilemap.set_cell(i, j, id)
	self.global_position = pos

	for i in tilemap.get_used_cells():
		var x = i[0]
		var y = i[1]
		var left = tilemap.get_cell(x - 1, y)
		var right = tilemap.get_cell(x + 1, y)
		var above = tilemap.get_cell(x, y - 1)
		var below = tilemap.get_cell(x, y + 1)

		if above == -1:
			tilemap.set_cell(x, y - 1 , 2)
		if below == -1:
			tilemap.set_cell(x, y + 1, 8)
		if left == -1:
			tilemap.set_cell(x - 1, y, 7)
		if right == -1:
			tilemap.set_cell(x + 1, y, 6)

func room_middle(room):
	return Vector2(room[round(len(room) / 2.0)][0], room[round(len(room) / 2.0)][1])

func get_colour():
	return COLOUR 

func set_colour(colour):
	COLOUR = colour
	
#func spawn_enemies():
#	for i in range(0,3): # Replace with function body.
#		var instance = GoblinNode.instance()
#		instance.set_position(Vector2(300.0, 350.0 - 20.0 * i))
#		instance.aggro_range = 199.0
#		self.add_child(instance)
#		instance.set_colour( round(rand_range(1.0,3.0)) )
#

extends Node2D

var max_x = 20; var max_y = 20
var min_x = 5; var min_y = 5 
var size = Vector2()
var corners = {"topright":Vector2(), "topleft":Vector2(), 
			   "bottomright":Vector2(), "bottomleft":Vector2(), 
			   "mid":Vector2(), "midleft": Vector2(), "midright": Vector2(),
			   "midtop":Vector2(), "midbottom": Vector2() }


var COLOUR = 2.0;
var radius = 0.0;
var change = false;
var tilesize = 16.0
onready var tilemap = get_node("TileMap")

const room_shader = preload("res://shaders/new_shader.shader")
var turret = preload("res://Objects/Turret.tscn")
onready var area = get_node("Area2D")
const door_tile_id = 5
const floor_tile_id = 5

onready var rootNode = get_tree().get_root().get_node("Root")
onready var Player = rootNode.get_node("Player")

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
	set_area()
	

func set_area():
	var shape = get_node("Area2D/CollisionShape2D").get_shape()
	shape.set_extents(size * (tilesize / 2.0) )
	area.position = (size / 2.0) * tilesize
	Player.area.connect("area_entered", Player, "printo")
	
	
func get_corners():
	return corners

func set_position(p):
	global_position = p - Vector2(floor(size.x / 2), floor(size.y / 2)) * tilesize

func generate_shaders():
	material = ShaderMaterial.new()
	material.set_shader(room_shader)
	self.set_material(material)
	self.set_colour(COLOUR)
	
func generate(pos, offset):
	generate_floor(pos, offset)
	generate_shaders()
	spawn_turrets()
	
func generate_floor(pos, offset):
	for i in range(0, size.x + 1):
		for j in range(0, size.y + 1):
			tilemap.set_cell(i, j, floor_tile_id)
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

func make_doors(dir):
	var door_placement;
	var corridor = Vector2()
	if dir["x"] == -1:
		door_placement = corners["midleft"]
		door_placement.x -= 1
		corridor.x = -3
	if dir["x"] == 1:
		door_placement = corners["midright"]
		door_placement.x += 1
		corridor.x = 3
	if dir["y"] == 1:
		door_placement = corners["midtop"]
		door_placement.y -= 1
		corridor.y = -3
	if dir["y"] == -1:
		door_placement = corners["midbottom"]
		door_placement.y += 1
		corridor.y = 3
	
	for i in range(0, corridor.x, sign(corridor.x)):
		for j in range(0, corridor.y, sign(corridor.y)):
			print(i,j)
			tilemap.set_cell(door_placement.x + i, door_placement.y + j, door_tile_id)
	
func spawn_turrets():
	for i in range(0,3):
		var turret_instance = turret.instance()
		self.add_child(turret_instance)
		turret_instance.global_position = Vector2(rand_range(0,size.x * tilesize), rand_range(0, size.y * tilesize))

func trigger(colour):
	if colour != COLOUR:
		radius = 0.0
		COLOUR = colour
		change = true
	print(material)
	material.set_shader_param("colour_mode", colour)

func _physics_process(delta):
	if change:
		var pos = Player.get_local_position()

		radius += 50.0
		material.set_shader_param("position", pos)
		material.set_shader_param("radius", radius)
	
		if radius >= 1000.0:
			change = false
			
#func spawn_enemies():
#	for i in range(0,3): # Replace with function body.
#		var instance = GoblinNode.instance()
#		instance.set_position(Vector2(300.0, 350.0 - 20.0 * i))
#		instance.aggro_range = 199.0
#		self.add_child(instance)
#		instance.set_colour( round(rand_range(1.0,3.0)) )
#

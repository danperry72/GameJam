extends Node2D	

onready var tilemap = get_node("TileMap")
var transform_speed = 0
var t = transform_speed
var index = 0
var master_id = 5 
var used_cells
var change = false
var chunk_speed = 10

onready var new_shader = preload("res://shaders/new_shader.shader")

# Called when the node enters the scene tree for the first time.
func _ready():
	used_cells = get_cells()

func set_cell(cell, id):
	tilemap.set_cell(cell[0], cell[1], id)

func get_cells():
	return tilemap.get_used_cells()
		
func super_set_cells():
	
	for i in used_cells:
		set_cell(i, master_id)

	index += 1


func trigger(colour):
	if colour == "Grey":
		var mat = ShaderMaterial.new()
		mat.set_shader(new_shader)
		tilemap.set_material(mat)
	elif colour == "Brown":
		master_id = 6
	change = true

func _physics_process(delta):
	if change:
		super_set_cells()
		#change = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

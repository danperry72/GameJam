extends Node2D

onready var tilemap = get_node("TileMap")
var transform_speed = 0
var t = transform_speed
var index = 0
var master_id = 5 
var used_cells
var change = false

# Called when the node enters the scene tree for the first time.
func _ready():
	used_cells = get_cells()

func set_cell(cell, id):
	tilemap.set_cell(cell[0], cell[1], id)

func get_cells():
	return tilemap.get_used_cells()
		
func super_set_cells():
	for i in used_cells:
		set_cell(used_cells[i], master_id)
	#t += 1
	#if t >= transform_speed:
	#	if index >= len(used_cells):
	#		index = 0
	#		change = false
	#	set_cell(used_cells[index], master_id)
	#	t = 0
	#	index += 1

func trigger(colour):
	if colour == "Grey":
		master_id = 5
	elif colour == "Brown":
		master_id = 6
	change = true
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if change:
		super_set_cells()

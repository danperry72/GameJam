extends Node2D

onready var player = get_node("Player")
onready var level = preload("res://Scenery/Level.tscn")
func _ready():
	randomize()
	var level_instance = level.instance()
	self.add_child(level_instance)
	
#func place_player():
#	var rand_room_n = randi()%len(roomlist)
#	var coords = room_middle( roomlist[rand_room_n]  )
#	var world_coords = coords * 16.0
#	player.global_position = world_coords

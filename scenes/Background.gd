extends Node2D	

var change = true
var radius = 0.0
var current_colour = 1.0

onready var background = get_node("../Sprite")

func trigger(colour):
	if colour != current_colour:
		radius = 0.0
		current_colour = colour
		change = true
	background.material.set_shader_param("colour_mode", current_colour)

func _physics_process(delta):
	if change:
		radius += 0.05
		background.material.set_shader_param("radius", radius)
	
		if radius >= 1.0:
			change = false
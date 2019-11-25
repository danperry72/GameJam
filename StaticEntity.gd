extends StaticBody2D
class_name staticEntity
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var COLOUR = 1.0;
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_colour(colour):
	self.COLOUR = colour


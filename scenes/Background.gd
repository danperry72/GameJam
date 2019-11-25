extends Node2D	

var change = true
var radius = 0.0
var current_colour = 1.0

onready var background = get_node("TopDown")
const shader = preload("res://shaders/new_shader.shader")
onready var rootNode = get_tree().get_root().get_node("Root")
onready var player = get_node("../Player")
func _ready():
	var mat = ShaderMaterial.new()
	mat.set_shader(shader)
	rootNode.set_material(mat)

func trigger(colour):
	if colour != current_colour:
		radius = 0.0
		current_colour = colour
		change = true
	rootNode.material.set_shader_param("colour_mode", current_colour)

func _physics_process(delta):
	if change:
		
		var pos = player.get_local_position()

		radius += 50.0
		rootNode.material.set_shader_param("position", pos)
		rootNode.material.set_shader_param("radius", radius)
	
		if radius >= 1000.0:
			change = false
extends entity
class_name Enemy
var following = false
var target
var reaction_time 
var COLOUR = 1.0;
var dead = false
export(float) var attack_range = 100.0
export(float) var aggro_range = 200.0
onready var sprite = get_node("AnimatedSprite");
const enemy_shader = preload("res://shaders/enemy.shader")
onready var rootNode = get_tree().get_root().get_node("Root")
# Called when the node enters the scene tree for the first time.
func _ready():
	entityType = "Enemy"
	target = get_node("../Player") # Replace with function body.
	reaction_time = rand_range(0.1, 1.5)
	var mat = ShaderMaterial.new()
	mat.set_shader(enemy_shader)
	self.set_material(mat)
	self.set_colour(COLOUR)
	
func set_colour(colour):
	self.material.set_shader_param("colour_mode", colour)
	COLOUR = colour
	
func entityType():
	print(entityType)
	return entityType

#func _process(delta):
#	if dead == false:
#		if rootNode.get_colour() == self.COLOUR:
#			self.die()
		
func _physics_process(delta):
	if dead == false:
		var target_pos = target.get_position()
		if following:
			if react():
				if self.get_position().distance_to(target.get_position()) < attack_range:
					pass
				if target_pos.x > self.global_position.x:
					self.change_input("x","right")
				elif target_pos.x < self.global_position.x:
					self.change_input("x","left")
				else: 
					self.change_input("x","idle")
				
		if self.get_position().distance_to(target.get_position()) < aggro_range:
			following = true
		
func react():
	reaction_time -= 0.1
	if reaction_time <= 0:
		reaction_time = rand_range(0.1, 1.5)
		return true
	else:
		return false

func die():
	if dead == false:
		dead = true
		#yield(self.anim, "animation_finished")
		get_parent().remove_child(self)
	
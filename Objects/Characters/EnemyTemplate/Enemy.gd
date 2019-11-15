extends Node2D
class_name Enemy
var following = false
var target
var body 
var reaction_time 
var entityType = "Enemy"
export(float) var attack_range = 100.0
export(float) var aggro_range = 200.0
# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_node("../Player") # Replace with function body.
	body = get_node("Body")
	reaction_time = rand_range(0.1, 1.5)

func entityType():
	print(entityType)
	return entityType
	
func _physics_process(delta):
	var target_pos = target.body.get_position()
	if following:
		if react():
			if body.get_position().distance_to(target.body.get_position()) < attack_range:
				body.attack("basic", self)
			if target_pos.x > body.global_position.x:
				body.change_input("x","right")
			elif target_pos.x < body.global_position.x:
				body.change_input("x","left")
			else: 
				body.change_input("x","idle")
			
	if body.get_position().distance_to(target.body.get_position()) < aggro_range:
		following = true
		
func react():
	reaction_time -= 0.1
	if reaction_time <= 0:
		reaction_time = rand_range(0.1, 1.5)
		return true
	else:
		return false

func die():
	print("ENEMY IS DEAD")
	yield(body.anim, "animation_finished")
	get_parent().remove_child(self)
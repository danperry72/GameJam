extends entity
class_name Enemy
var following = false
var target
var reaction_time 

export(float) var attack_range = 100.0
export(float) var aggro_range = 200.0
const enemy_instance = preload("res://Dino.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	entityType = "Enemy"
	target = get_node("../Player") # Replace with function body.
	reaction_time = rand_range(0.1, 1.5)

func entityType():
	print(entityType)
	return entityType
	
func _physics_process(delta):
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
	print("ENEMY IS DEAD")
	for i in range(0,10):
		var instance = enemy_instance.instance()
		instance.set_position(self.get_position())
	yield(self.anim, "animation_finished")
	get_parent().remove_child(self)
	
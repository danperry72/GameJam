extends Node2D

var body
var entityType = "Player"
# Called when the node enters the scene tree for the first time.
func _ready():
	body = get_node("physicsbody")
	
func entityType():
	print(entityType)
	return entityType
	
func input():
	if(Input.is_action_pressed("left")):
		body.change_input("x","left")
	elif(Input.is_action_pressed("right")):
		body.change_input("x","right")
	elif(Input.is_action_just_released("right")):
		body.change_input("x","idle")
	elif(Input.is_action_just_released("left")):
		body.change_input("x","idle")
	else:
		body.change_input("x","idle")
	if(Input.is_action_just_pressed("jump")):
		body.change_input("y","jump")
	if(Input.is_mouse_button_pressed(1)):
		body.change_input("attack", "basic")
	else:
		body.change_input("attack", "idle")

func transform(target):
	var pos = body.get_position()
	self.remove_child(body)

	if target != null:
		body = target.get_parent().get_node("Body")
		target.get_parent().remove_child(body)
		self.add_child(body)

	body.set_position(pos)
	body.HP = body.max_HP
	body.state = "idle"
	body.dead_state = false
	body.add_camera()
	
func die():
	print("PLAYER WAS KILLED BY", body.attacked_by)
	body.anim.disconnect("animation_finished", body, "die")
	transform(body.attacked_by)
	
func _process(delta):
	input()
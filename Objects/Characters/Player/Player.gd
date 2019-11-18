extends entity

var tilemap
var background_colour = "Brown"# Called when the node enters the scene tree for the first time.
func _ready():
	#body = get_node("physicsbody")
	entityType = "Player"
	anim = get_node("AnimatedSprite")
	hitbox = get_node("CollisionShape2D")
	tilemap = get_node("../ParallaxBackground/Background")
	add_camera()

func add_camera():
	var cameraNode = camera.instance()
	self.add_child(cameraNode)

func update_sprite():
	if state == "dying":
		if not dead_state:
			anim.connect("animation_finished", self, "die")
			dead_state = true
		anim.play(state)
		velocity = Vector2(0,0)
	else:
		if attack_state != "idle":
			anim.play(attack_state)
		else:
			anim.play(state)
	
		if facing == "right":
			anim.set_flip_h( false )
		else:
			anim.set_flip_h( true )

func entityType():
	print(entityType)
	return entityType
	
func shift_colour():
	if tilemap.change != true:
		if background_colour == "Brown":
			background_colour = "Grey"
		elif background_colour == "Grey":
			background_colour = "Brown"
		tilemap.trigger(background_colour)


func input():
	if(Input.is_action_pressed("colour_shift")):
		shift_colour()
	if(Input.is_action_pressed("left")):
		self.change_input("x","left")
	elif(Input.is_action_pressed("right")):
		self.change_input("x","right")
	elif(Input.is_action_just_released("right")):
		self.change_input("x","idle")
	elif(Input.is_action_just_released("left")):
		self.change_input("x","idle")
	else:
		self.change_input("x","idle")
	if(Input.is_action_just_pressed("jump")):
		self.change_input("y","jump")
	if(Input.is_mouse_button_pressed(1)):
		self.change_input("attack", "basic")
	else:
		self.change_input("attack", "idle")
	
func die():
	print("PLAYER WAS KILLED BY", self.attacked_by)
	self.anim.disconnect("animation_finished", self, "die")

	
func _process(delta):
	input()
extends KinematicBody2D
class_name entity

var velocity = Vector2()
export(float) var accel = 100.0
var state = "idle"
export(float) var gravity = 300.0
export(float) var max_speed = 200.0
var floor_normal = Vector2(0,-1)
var facing = "right"
var INPUT = {"x":["idle"], "y":[], "attack":[]}
var attack_state = "idle"
export(int) var max_HP = 50
onready var hitbox = get_node("CollisionShape2D")

var HP = max_HP
var dead_state = false
var entityType
var anim
var camera = preload("res://scenes/camera.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("AnimatedSprite")
	
func entityType():
	return entityType
		
func get_input():
	if (state != "dying"):
		if INPUT["x"] or INPUT["y"]:
			if("left" in INPUT["x"]):
				impulse(Vector2(-1.0,0.0))
				if state != "jumping": state = "running"
				facing = "left"
			elif("right" in INPUT["x"]):
				impulse(Vector2(1.0,0.0))
				if state != "jumping": state = "running"
				facing = "right"
			
			if("down" in INPUT["y"]):
				impulse(Vector2(0.0,1.0))
				state = "running"
			elif("up" in INPUT["y"]):
				impulse(Vector2(0.0,-1.0))
				state = "running"
		else:
			state = "idle"

func damage(damage):
	self.HP -= damage
	if self.HP <= 0:
		if state != "dying":
			self.dying()

func dying():
	state = "dying"

func die():
	dead_state = true
	get_parent().die()
		
func change_input(type, value):
	INPUT[type] = value

func get_position():
	return global_position

func get_local_position():
	return self.get_viewport_transform() * global_position
	
func set_position(pos):
	self.global_position = pos
	
func _physics_process(delta):
	process_state()
	get_input()
	move()
	friction()
	update_sprite()

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

func process_state():
	if state != "running" and state != "dying":
		state = "idle"

func impulse(vector):
	velocity += accel * vector
	
func friction():
	if entityType != "Projectile":
		if("idle" in INPUT["x"]):
			velocity.x *= 0.8
		if("idle" in INPUT["y"]):
			velocity.y *= 0.8
	
func move():
	velocity.x = clamp( velocity.x, -max_speed, max_speed )
	velocity.y = clamp( velocity.y, -max_speed, max_speed )
	velocity = move_and_slide( velocity, floor_normal )

func get_vel():
	return velocity

extends KinematicBody2D
class_name entity

var velocity = Vector2()
export(float) var accel = 100.0
var jump_accel = 200.0
var state = "idle"
export(float) var gravity = 300.0
export(float) var max_speed = 200.0
var group = "enemy"
var floor_normal = Vector2(0,-1)
var facing = "right"
var INPUT = {"x":["idle"], "y":[], "attack":[]}
var attack_state = "idle"
export(int) var max_HP = 50
onready var hitbox = get_node("CollisionShape2D")
var HP = max_HP
var attacked_by
var dead_state = false
var entityType
var anim
var camera = preload("res://scenes/camera.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	anim = get_node("AnimatedSprite")
		
func get_input():

	if (state != "dying"):
		if("left" in INPUT["x"]):
			impulse(Vector2(-1.0,0.0))
			if state != "jumping": state = "running"
			facing = "left"
		if("right" in INPUT["x"]):
			impulse(Vector2(1.0,0.0))
			if state != "jumping": state = "running"
			facing = "right"
		if("idle" in INPUT["x"]):
			if state != "jumping": state = "idle"
		if("jump" in INPUT["y"] and is_on_floor()):
			state = "jumping"
			INPUT["y"] = []
			velocity.y += -jump_accel
	
		if("basic" in INPUT["attack"]  and is_on_floor()):
			attack_state = "attacking-ground"
			attack("basic", self)
		else:
			attack_state = "idle"

func attack(type, attacker):
	for i in range(get_slide_count() - 1):
		var collision = get_slide_collision(i)
		if collision.collider.get_class() == "KinematicBody2D":
			if collision.collider.state != "dying":
				collision.collider.damage(5)
				collision.collider.attacked_by(self)
			
func attacked_by(entity):
	attacked_by = entity
	
func damage(damage):
	self.HP -= damage
	if self.HP <= 0:
		if state != "dying":
			self.dying()

func dying():
	state = "dying"

func die():
	get_parent().die()
		
func change_input(type, value):
	INPUT[type] = value

func get_position():
	return global_position

func set_position(pos):
	self.global_position = pos
	
func _physics_process(delta):
	process_state()
	velocity += Vector2(0, gravity * delta)
	get_input()
	move()
	if state != "running":
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
	if is_on_floor() and state != "running" and state != "dying":
		state = "idle"

func gravity():
	velocity += Vector2( 0, gravity )
	

func impulse(vector):
	velocity += accel * vector
	

func friction():
	velocity.x *= 0.8
	
func move():
	#if is_on_floor() and state != "jumping":
	#	velocity.y = 0
	velocity.x = clamp( velocity.x, -max_speed, max_speed )
	velocity = move_and_slide( velocity, floor_normal )

func get_vel():
	return velocity

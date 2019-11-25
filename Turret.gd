extends staticEntity

onready var background = get_node("../Background")
onready var fireball = preload("res://Objects/Fireballs.tscn")
var firerate = 120;
var t = 0;
onready var rootNode = get_tree().get_root().get_node("Root")
func _ready():
	COLOUR = round(rand_range(1.0, 3.0))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if background.current_colour == self.COLOUR:
		t += 1
		if t >= firerate:
			shoot()
			t = 0
	
func shoot():
	var dist = 1000000.0
	var closest;
	for i in rootNode.get_children():
		if i.get_class() == "KinematicBody2D":
			if i.entityType() == "Enemy":
				var dist2 = abs(global_position.distance_squared_to(i.get_position()))
				if dist2 < dist:
					dist = dist2
					closest = i
					
	var new_fireball = fireball.instance()
	var vecdiff = new_fireball.global_position - closest.get_position()
	new_fireball.rotation = (vecdiff).angle() + sign(vecdiff.x) *  PI/2.0
	new_fireball.entityType = "Projectile"
	self.add_child(new_fireball)
#	new_fireball.look_at(closest.get_position())
	new_fireball.impulse( (new_fireball.global_position - closest.get_position()).normalized() )
	
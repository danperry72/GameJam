extends staticEntity

onready var background = get_node("../Background")
onready var fireball = preload("res://Objects/Fireballs.tscn")
var firerate = 5;
export(float) var START_COLOUR = 0.0;
var t = 0;
const enemy_shader = preload("res://shaders/enemy.shader")
onready var rootNode = get_tree().get_root().get_node("Root")
func _ready():
	if START_COLOUR == 0.0:
		COLOUR = randi()%3+1
		print(COLOUR)
	else:
		COLOUR = START_COLOUR
	var mat = ShaderMaterial.new()
	mat.set_shader(enemy_shader)
	self.set_material(mat)
	mat.set_shader_param("colour_mode", COLOUR)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if(Input.is_action_pressed("mouse_down")):
		mouse_shoot()
#	if background.current_colour == self.COLOUR:
#		t += 1
#		if t >= firerate:
#			shoot("manual")
#			t = 0
	
func mouse_shoot():
	if background.current_colour == self.COLOUR:
		t += 1
		if t >= firerate:
			shoot("manual")
			t = 0

func shoot(mode):
	var target;
	if mode == "auto":
		var dist = 1000000.0
		for i in rootNode.get_children():
			if i.get_class() == "KinematicBody2D":
				if i.entityType() == "Enemy" and i.dead_state == false:
					var pos = i.get_position()
					var dist2 = abs(global_position.distance_squared_to(pos))
					if dist2 < dist:
						dist = dist2
						target = pos
	elif mode == "manual":
		target = rootNode.get_global_mouse_position()
		
	if target != null:
		var new_fireball = fireball.instance()
		new_fireball.global_position = global_position + Vector2(0.0, -10.0)	
		new_fireball.target(target)
		rootNode.add_child(new_fireball)
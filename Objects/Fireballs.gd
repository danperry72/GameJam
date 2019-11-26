extends entity		

var lifetime = 100
# Called when the node enters the scene tree for the first time.
func _ready():
	entityType = "Projectile"

func _physics_process(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		var entity = collision.get_collider()
		if entity.get_class() == "KinematicBody2D":
			if entity.entityType() == "Enemy":
				if entity.dead_state == false:
					entity.die()
				self.die()
		else:
			self.die()
	._physics_process(delta)

	lifetime -= 1
	if lifetime <= 0:
		self.die()

func target(target):
	var vecdiff = global_position - target
	rotation = (vecdiff).angle() - PI / 2.0
	impulse( -(vecdiff).normalized() )

func die():
	if dead_state == false:
		dead_state = true
		get_parent().remove_child(self)
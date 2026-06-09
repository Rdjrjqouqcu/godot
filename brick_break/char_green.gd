extends CharacterBody2D

## pixels per second
const INPUT_SPEED = 1
## pixels per second
const MOVE_SPEED = 10

var last_velocity = Vector2.RIGHT * MOVE_SPEED

func _physics_process(_delta):
	var vect = Input.get_vector("left", "right", "up", "down") * INPUT_SPEED
	velocity = (last_velocity + vect).normalized() * MOVE_SPEED
	last_velocity = velocity
	var collision = move_and_collide(velocity)
	while collision != null:
		#KinematicCollision2D
		vect = collision.get_remainder().bounce(collision.get_normal())
		last_velocity = vect.normalized() * MOVE_SPEED
		collision = move_and_collide(vect)
		

func _on_ready():
	velocity = last_velocity

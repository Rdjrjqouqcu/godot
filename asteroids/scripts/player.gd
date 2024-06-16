extends CharacterBody2D

@export_group("velocity")
## p/s
@export var max_velocity = 800
## additional p/s
@export var additional_velocity = 200

@export_group("break")
@export var use_break_as_percent = true
## p/s velocity loss or %/s
@export var brake_velocity = 0.1

@export_group("rotation")
#@export_enum("NYI") var rotation_momentum_enabled = "NYI"
### degrees/s NYI - use change_in_rotation instead
#@export var max_rotation = 3
## degrees/s
@export var change_in_rotation = 180

@export_group("drag")
@export var use_drag_as_percent = false
## p/s velocity loss or %/s
@export var velocity_drag = 100
## degrees/s rotational loss or %degrees/s
@export var rotation_drag = 1

# embedded and applied by move_and_slide
# var velocity: Vector2 
var last_velocity: Vector2
var last_angular_velocity: float

func _ready():
	last_velocity = Vector2(0, 200)
	last_velocity = Vector2(0, 0)
	#last_velocity = Vector2(800, 0)
	velocity = last_velocity
	last_angular_velocity = 0
	rotation = 0

func _process(delta):
	var target_velocity := Vector2.ZERO
	if Input.is_action_pressed("up"):
		# accelerate

		var next_velocity = Vector2.from_angle(rotation).normalized() * additional_velocity * delta
		var orthonal_projection = last_velocity - last_velocity.project(next_velocity)

		target_velocity = last_velocity + next_velocity
		if abs(next_velocity.angle_to(target_velocity)) > deg_to_rad(5):
			# only cancel out orthogonals if > 5 degree difference
			target_velocity = target_velocity - additional_velocity * delta * orthonal_projection.normalized()

		$Label2.text = str(floor(orthonal_projection.length()))

		#print(last_velocity.floor(), next_velocity.floor(), target_velocity.floor(), orthonal_projection.normalized())
		target_velocity = target_velocity.limit_length(max_velocity)
		velocity = target_velocity
	elif Input.is_action_pressed("down") or true:
		if use_break_as_percent:
			velocity = velocity * (1 - delta * (1 - brake_velocity))
		else:
			velocity = velocity.limit_length(max(0, velocity.length() - delta * brake_velocity))
		if velocity.length() < 5:
			velocity = Vector2.ZERO
			$Timer.stop()
	else:
		if use_drag_as_percent:
			velocity = velocity *  (1 - 0.5 * delta)
		else:
			velocity = velocity.limit_length(max(0, velocity.length() - delta * velocity_drag))
		if velocity.length() < 5:
			velocity = Vector2.ZERO
			$Timer.stop()
		pass
	last_velocity = velocity
	$Label.text = str(floor(velocity.length()))
	
	var rotation_direction = 0
	if Input.is_action_pressed("right"):
		rotation_direction += 1
	if Input.is_action_pressed("left"):
		rotation_direction -= 1
	rotate(rotation_direction * deg_to_rad(change_in_rotation) * delta)
	move_and_slide()

#func _integrate_forces(state):
	#var xform = state.transform
	#var screen_size = get_viewport_rect().size
	#xform.origin.x = wrapf(xform.origin.x, 0, screen_size.x)
	#xform.origin.y = wrapf(xform.origin.y, 0, screen_size.y)
	#state.transform = xform



var counter = 0
func timeout():
	counter += 1
	$Label3.text = str(counter)

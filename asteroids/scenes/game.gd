extends Node

var meteorFactory = preload("res://scenes/meteor.tscn")
const radius = 1000
const max_vel = 200
# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(33):
		var meteor = meteorFactory.instantiate()
		match  randi_range(0,3):
			0:
				meteor.init_brown_small_1()
			1:
				meteor.init_brown_small_2()
			2:
				meteor.init_brown_tiny_1()
			3:
				meteor.init_brown_tiny_2()
				
		while meteor.get_contact_count() != 0:
			meteor.global_position = Vector2i(randi_range(-radius,radius), randi_range(-radius,radius))
		meteor.set_rotation(deg_to_rad(randi_range(0,360)))
		meteor.apply_central_impulse(Vector2.from_angle(meteor.rotation) * randi_range(0,max_vel))
		add_child(meteor)






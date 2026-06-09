extends RigidBody2D
class_name BasicBlock

@export var variance_degrees: float = 15.0

func on_ball_hit() -> void:
	Loggie.info("ball hit")
	pass

func get_bounce_degree_offset() -> float:
	return randf_range(-variance_degrees, variance_degrees)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass

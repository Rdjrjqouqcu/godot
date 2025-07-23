extends RigidBody2D
class_name BasicBlock

@export var variance_degrees: float = 15.0

func break_block() -> void:
	$BreakAnimation.restart()
	$Sprite2D.hide()
	$CollisionShape2D.set_disabled(true)

func on_ball_hit() -> void:
	Loggie.info("ball hit")
	if randi() % 4 == 0:
		break_block()

func get_bounce_degree_offset() -> float:
	return randf_range(-variance_degrees, variance_degrees)

func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	pass


func _on_break_animation_finished() -> void:
	queue_free()

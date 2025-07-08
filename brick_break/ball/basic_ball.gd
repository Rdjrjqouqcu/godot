extends CharacterBody2D

@export var speed: float = 300.0


func _ready() -> void:
	velocity = Vector2.RIGHT.normalized() * speed

func _physics_process(delta: float) -> void:

	velocity = velocity.normalized() * speed
	var collide = move_and_collide(velocity * delta)
	if collide != null:
		var variance_deg = 0
		if collide.get_collider() is BasicBlock:
			var block = collide.get_collider() as BasicBlock
			variance_deg = block.get_bounce_degree_offset()
			block.on_ball_hit()
		velocity = velocity.bounce(collide.get_normal()).rotated(deg_to_rad(variance_deg))

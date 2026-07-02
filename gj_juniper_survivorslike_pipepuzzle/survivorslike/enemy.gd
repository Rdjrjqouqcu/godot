extends CharacterBody2D
class_name Enemy

const SPEED = 50.0


func _physics_process(_delta: float) -> void:
	var direction = position.direction_to(Player.instance.position)
	velocity = direction * SPEED
	move_and_slide()

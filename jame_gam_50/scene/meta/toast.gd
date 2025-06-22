extends Label

@export var lifetime_ms: float = 1_50
@export var arc_degrees: float = 15.0
@export var velocity: float = 10
var direction: Vector2

func _ready() -> void:
	direction = Vector2.UP.rotated(deg_to_rad(randf_range(-arc_degrees, arc_degrees)))


func _process(delta: float) -> void:
	position = position + velocity * direction * delta
	lifetime_ms -= delta * 100
	if lifetime_ms <= 0:
		queue_free()

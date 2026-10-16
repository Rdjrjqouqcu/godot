extends Sprite2D


const VELOCITY = Vector2(0, -100)
const VELOCITY_RANGE = Vector2(80, 120)
const VELOCITY_DIRECTION = Vector2(0, -1)
const VELOCITY_ANGLE_DEG = Vector2(-15,15)

const FADE_DELAY = Vector2(2.0, 3.0)
const FADE_TIME = Vector2(1.0, 2.0)

var selected_velocity: Vector2
var tween: Tween
func _ready() -> void:
	selected_velocity = VELOCITY_DIRECTION.rotated(
		deg_to_rad(randf_range(VELOCITY_ANGLE_DEG.x, VELOCITY_ANGLE_DEG.y))
	)
	selected_velocity = selected_velocity.normalized() * randf_range(VELOCITY_RANGE.x, VELOCITY_RANGE.y)
	tween = create_tween()
	tween.tween_interval(randf_range(FADE_DELAY.x, FADE_DELAY.y))
	tween.tween_method(
		func(x): set_instance_shader_parameter("alpha", x),
		1.0,
		0.0,
		randf_range(FADE_TIME.x, FADE_TIME.y)
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	self.position = position + delta * selected_velocity


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

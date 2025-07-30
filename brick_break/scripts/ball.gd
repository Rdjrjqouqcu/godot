extends CharacterBody2D

@export var speed: float = 300.0

const SCALE_DOWN_CURVE = preload("res://sprites/scale_down_curve.tres")
const CIRCLE_032 = preload("res://sprites/shapes/circle.032.png")

func _play_collision_splash(location: Vector2) -> void:
	var color_list = [Globals.COLOR_ORANGE, Globals.COLOR_PURPLE]
	for color in color_list:
		var splash: CPUParticles2D = CPUParticles2D.new()
		splash.amount = 16.0 / color_list.size()
		splash.texture = CIRCLE_032
		splash.lifetime = 0.5
		splash.one_shot = true
		splash.explosiveness = 1.0
		splash.gravity = Vector2i.ZERO
		splash.initial_velocity_min = 150
		splash.initial_velocity_max = 150
		splash.spread = 180
		splash.scale_amount_curve = SCALE_DOWN_CURVE
		splash.modulate = color
		splash.global_position = location
		splash.finished.connect(splash.queue_free)
		$splashes.add_child(splash)

func _on_bounce(col: KinematicCollision2D) -> void:
	_play_collision_splash(col.get_position())

func _ready() -> void:
	self.modulate = Globals.COLOR_LIME
	velocity = Vector2.RIGHT.normalized() * speed

func _physics_process(delta: float) -> void:
	velocity = velocity.normalized() * speed
	var collide = move_and_collide(velocity * delta)
	if collide != null:
		var variance_deg = 0
		if collide.get_collider() is Block:
			var block = collide.get_collider() as Block
			variance_deg = block.get_bounce_degree_offset()
			block.on_ball_hit()
		_on_bounce(collide)
		velocity = velocity.bounce(collide.get_normal()).rotated(deg_to_rad(variance_deg))

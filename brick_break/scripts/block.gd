extends RigidBody2D
class_name Block

@export var variance_degrees: float = 5.0
@export var indestructible: bool = false
@export var log_hit: bool = false

var root:Main

const BASIC_BLOCK = preload("res://scenes/block.tscn")

static func new_border_block(pos:Vector2i, aroot:Main) -> Block:
	var block = BASIC_BLOCK.instantiate()
	block.variance_degrees = 0
	block.indestructible = true
	block.modulate = Globals.COLOR_TRANSPARENT
	block.position = Globals.map_position(pos)
	block.root = aroot
	return block

static func new_basic_block(pos:Vector2i, aroot:Main) -> Block:
	var block = BASIC_BLOCK.instantiate()
	block.modulate = Globals.COLOR_BLUE
	block.position = Globals.map_position(pos)
	block.root = aroot
	return block

func break_block() -> void:
	$BreakAnimation.restart()
	$Sprite2D.hide()
	$CollisionShape2D.set_disabled(true)

func on_ball_hit() -> void:
	if log_hit:
		Loggie.info("ball hit")
	if indestructible:
		return
	break_block()

func get_bounce_degree_offset() -> float:
	return randf_range(-variance_degrees, variance_degrees)

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass


func _on_break_animation_finished() -> void:
	queue_free()

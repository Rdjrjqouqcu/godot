extends Node2D
class_name Block

@export var durability: int = 0
var break_height: int = 0
var is_breaking: bool = false

var break_particles: Array[Node]
var break_finished: int = 0
func _break_finished() -> void:
	break_finished += 1
	if break_finished == break_particles.size():
		queue_free()
func _break() -> void:
	is_breaking = true
	for part in break_particles:
		part.restart()
	self_modulate.a = 0 # hide sprite

func hit(height: int) -> bool:
	Loggie.info("block hit", height, break_height)
	if height >= break_height:
		_break()
		return true
	return false

func _ready() -> void:
	break_height = Globals.HEIGHT_LEVELS[durability]
	break_particles = find_children("*", "CPUParticles2D")
	for part in break_particles:
		(part as CPUParticles2D).finished.connect(_break_finished)
	add_to_group(Globals.GROUP_BLOCKS)

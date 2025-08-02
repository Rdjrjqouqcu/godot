extends Node2D
class_name Block

var level: Level

@export var durability: int = 0
@export var is_target: bool = false
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
	if $break_audio:
		$break_audio.volume_linear = level.get_volume()
		$break_audio.play()
	level.update_score()
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
	if is_target:
		add_to_group(Globals.GROUP_TARGETS)
	var parent = get_parent()
	while not parent is Level:
		parent = parent.get_parent()
	level = parent as Level

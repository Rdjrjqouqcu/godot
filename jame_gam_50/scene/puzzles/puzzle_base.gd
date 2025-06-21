extends Node2D
class_name PuzzleBase

var offsets: Array[Vector2i] = [Vector2i.ZERO]
var locations: Array[Vector2i]
var is_circuit: bool = false
var spawn_cooldown_min: int = 100
var spawn_cooldown_max: int = 100
var complete_cooldown_min: int = -1
var complete_cooldown_max: int = -1

var pop_loss_min: int = 1_000
var pop_loss_max: int = 10_000

var root: Main

func can_fit(loc: Vector2i, board: Dictionary[Vector2i, bool]) -> bool:
	var ret = true
	for off in offsets:
		ret = ret && !board.get(Vector2i(loc.x + off.x, loc.y + off.y), true)
	return ret

static func get_new() -> PuzzleBase:
	return null

func init(location: Vector2i, roots: Main) -> void:
	position = location * 120
	root = roots
	locations = []
	for off in offsets:
		locations.append(location + off)
	root.mark_add_puzzle(locations, is_circuit, randi_range(spawn_cooldown_min, spawn_cooldown_max))
	root.add_child(self)

func pass_puzzle() -> void:
	#Loggie.info("pass", self.position / 120)
	root.mark_free_puzzle(locations, is_circuit, randi_range(complete_cooldown_min, complete_cooldown_max))
	queue_free()
	if is_circuit:
		root.add_circuit()
	
func fail_puzzle() -> void:
	#Loggie.info("fail", self.position / 120)
	root.mark_free_puzzle(locations, is_circuit, randi_range(complete_cooldown_min, complete_cooldown_max))
	root.lose_population(randi_range(pop_loss_min, pop_loss_max))
	queue_free()

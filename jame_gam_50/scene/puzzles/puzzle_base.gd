extends Node2D
class_name PuzzleBase

const TOAST = preload("res://scene/meta/toast.tscn")

var offsets: Array[Vector2i] = [Vector2i.ZERO]
var center_offset: Vector2 = Vector2(0.5, 0.5)
var locations: Array[Vector2i]
var is_circuit: bool = false
var is_mega_circuit: bool = false
var spawn_cooldown_min: int = 100
var spawn_cooldown_max: int = 100
var complete_cooldown_min: int = -1
var complete_cooldown_max: int = -1

var pop_loss_min: int = 1_000
var pop_loss_max: int = 5_000

var root: Main

func can_fit(loc: Vector2i, board: Dictionary[Vector2i, bool]) -> bool:
	var ret = true
	for off in offsets:
		ret = ret && !board.get(Vector2i(loc.x + off.x, loc.y + off.y), true)
	return ret

func init(location: Vector2i, roots: Main) -> void:
	position = location * 120
	root = roots
	var f = get_node_or_null("frames") as Node2D
	if f != null:
		f.visible = roots.debug_info
	locations = []
	for off in offsets:
		locations.append(location + off)
	root.mark_add_puzzle(locations, is_circuit or is_mega_circuit, spawn_cooldown_min, spawn_cooldown_max)
	root.get_puzzle_node().add_child(self)

func pass_puzzle() -> void:
	#Loggie.info("pass", self.position / 120)
	root.mark_free_puzzle(locations, is_circuit or is_mega_circuit, complete_cooldown_min, complete_cooldown_max)
	var pop = root.modify_population_loss(randi_range(pop_loss_min, pop_loss_max))
	var toast_text = ""
	if pop != 0:
		toast_text = "saved " + root.comma_format(pop)
	queue_free()
	if is_circuit:
		root.add_circuit()
		toast_text = "circuit constructed"
	if is_mega_circuit:
		root.add_mega_circuit()
	if toast_text != "":
		var toast = TOAST.instantiate()
		toast.position = position + 120 * center_offset
		toast.text = toast_text
		root.add_child(toast)

func fail_puzzle() -> void:
	#Loggie.info("fail", self.position / 120)
	root.mark_free_puzzle(locations, is_circuit or is_mega_circuit, complete_cooldown_min, complete_cooldown_max)
	var pop = root.modify_population_loss(randi_range(pop_loss_min, pop_loss_max))
	root.lose_population(pop)
	var toast_text = ""
	if pop != 0:
		toast_text = "lost " + root.comma_format(pop)
	if is_circuit or is_mega_circuit:
		toast_text = "circuit broken"
	if toast_text != "":
		var toast = TOAST.instantiate()
		toast.position = position + 120 * center_offset
		toast.text = toast_text
		root.add_child(toast)
	queue_free()

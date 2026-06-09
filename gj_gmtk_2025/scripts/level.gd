extends Node2D
class_name Level

var starting_targets: float
var half_targets: float
const STAR = preload("res://assets/simpleShapes/Star.png")

func _remaining_targets() -> int:
	return get_tree().get_nodes_in_group(Globals.GROUP_TARGETS).filter(
		func(x): return not x.is_breaking
	).size()
func _remaining_blocks() -> int:
	return get_tree().get_nodes_in_group(Globals.GROUP_BLOCKS).filter(
		func(x): return not x.is_breaking
	).size()

func is_debug_enabled() -> bool:
	return %debug.is_pressed()
func _restart() -> void:
	get_tree().reload_current_scene()
func cell_get_block(coord: Vector2i) -> Block:
	var pos = Globals.map_coord_to_pos(coord)
	for child in get_tree().get_nodes_in_group(Globals.GROUP_BLOCKS):
		if pos == (child as Block).global_position:
			return child
	return null
func cell_contains_block(coord: Vector2i) -> bool:
	return cell_get_block(coord) != null
func get_volume() -> float:
	return %volume.value

var star_one: bool = true
var star_two: bool = true
var star_three: bool = true
func update_score() -> void:
	var targets = _remaining_targets()
	Loggie.info("score", targets, half_targets, starting_targets)
	if targets <= half_targets and star_one:
		star_one = false
		%star1.texture = STAR
		%star1.modulate = Globals.COLOR_BRONZE
	if targets == 0 and star_two:
		star_two = false
		%star2.texture = STAR
		%star2.modulate = Globals.COLOR_SILVER
	if _remaining_blocks() == 0 and star_three:
		star_three = false
		%star3.texture = STAR
		%star3.modulate = Globals.COLOR_GOLD


func _ready() -> void:
	starting_targets = _remaining_targets()
	half_targets = starting_targets / 2.0
	Loggie.info("block count", _remaining_blocks())

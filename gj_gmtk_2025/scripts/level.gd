extends Node2D
class_name Level


func is_debug_enabled() -> bool:
	return %debug.is_pressed()
func _restart() -> void:
	get_tree().reload_current_scene()
func cell_get_block(coord: Vector2i) -> Block:
	var pos = Globals.map_coord_to_pos(coord)
	for child in get_tree().get_nodes_in_group(Globals.GROUP_BLOCKS):
		if pos == (child as Block).position:
			return child
	return null
func cell_contains_block(coord: Vector2i) -> bool:
	return cell_get_block(coord) != null

func _ready() -> void:
	Loggie.info("block count", get_tree().get_node_count_in_group(Globals.GROUP_BLOCKS))

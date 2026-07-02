extends Node2D
class_name BigTile


const size: Vector2i = Vector2i(32 * 2,32 * 2)

var loc: Vector2i

# 0, 1
# 2, 3
var subtiles: Array[Tile]
func _grid_allocate_children(c: Dictionary[Vector2i, Node]) -> void:
	subtiles = [
		c[Vector2i(0,0)] as Tile,
		c[Vector2i(0,1)] as Tile,
		c[Vector2i(1,0)] as Tile,
		c[Vector2i(1,1)] as Tile,
	]

func rotate_tile() -> void:
	for t in subtiles:
		t.rotate_tile()
	var tmp = subtiles[0].get_connections()
	subtiles[0].update_connections.callv(subtiles[1].get_connections())
	subtiles[1].update_connections.callv(subtiles[3].get_connections())
	subtiles[3].update_connections.callv(subtiles[2].get_connections())
	subtiles[2].update_connections.callv(tmp)

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			rotate_tile()
			Level.instance.recalc_paths()

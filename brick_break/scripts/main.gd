extends Node
class_name Main

var block_map: Dictionary[Vector2i, Block] = {}


func _ready() -> void:
	# add border
	for i in range(-1, Globals.BOARD_WIDTH + 1):
		$border.add_child(Block.new_border_block(Vector2i(-1, i)))
		$border.add_child(Block.new_border_block(Vector2i(Globals.BOARD_HEIGHT, i)))
	for i in range(0, Globals.BOARD_HEIGHT):
		$border.add_child(Block.new_border_block(Vector2i(i, -1)))
		$border.add_child(Block.new_border_block(Vector2i(i, Globals.BOARD_WIDTH)))
	# add spawners
	for i in range(0, Globals.BOARD_WIDTH):
		for j in range(0, Globals.BOARD_HEIGHT):
			$spawners.add_child(Spawner.new_spawner(Vector2i(i, j), self))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

extends Node
class_name Main

var block_map: Dictionary[Vector2i, Block] = {}

func has_block_at(pos: Vector2i) -> bool:
	return block_map.get(pos) != null

func add_block_at(block:Block, pos:Vector2i) -> void:
	block_map[pos] = block
	$blocks.add_child(block)


func _ready() -> void:
	# add border
	for i in range(-1, Globals.BOARD_WIDTH + 1):
		$border.add_child(Block.new_border_block(Vector2i(-1, i), self))
		$border.add_child(Block.new_border_block(Vector2i(Globals.BOARD_HEIGHT, i), self))
	for i in range(0, Globals.BOARD_HEIGHT):
		$border.add_child(Block.new_border_block(Vector2i(i, -1), self))
		$border.add_child(Block.new_border_block(Vector2i(i, Globals.BOARD_WIDTH), self))
	# add spawners
	for i in range(0, Globals.BOARD_WIDTH):
		for j in range(0, Globals.BOARD_HEIGHT):
			$spawners.add_child(Spawner.new_spawner(Vector2i(i, j), self))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

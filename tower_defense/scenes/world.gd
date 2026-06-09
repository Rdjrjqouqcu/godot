extends Node2D
class_name World

static var instance: World

var slots: Dictionary[Vector2i, Slot] = {}
func getSlotAt(pos: Vector2i) -> Slot:
	if slots.has(pos):
		return slots.get(pos)
	return null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	World.instance = self
	var is_goal = false
	var is_spawn = false
	slots.clear()
	for r in range(Globals.ROWS):
		for c in range(Globals.COLS):
			is_spawn = r == 0 and c == 0
			is_spawn = is_spawn or ( r == Globals.ROWS - 1 and c == 0)
			is_goal = r == Globals.ROWS - 1 and c == Globals.COLS - 1
			is_goal = is_goal or (r == 0 and c == Globals.COLS - 1)
			var pos = Vector2i(c, r)
			var s = Slot.instantiate(self, pos, is_goal, is_spawn)
			slots.set(pos, s)
			%slots.add_child(s)
	get_tree().get_first_node_in_group(Globals.GROUP_SLOTS).update_all_paths()
	$board.queue_free()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

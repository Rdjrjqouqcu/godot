extends Node2D
class_name Main

const GROUP_SLOTS = "slots"
const ROWS = 20
const COLS = 20

var slot_cache: Dictionary[Vector2i, Slot] = {}

func get_ore_map() -> Array[Dictionary]:
	var red: Dictionary[Vector2i, int] = {}
	var green: Dictionary[Vector2i, int] = {}
	var blue: Dictionary[Vector2i, int] = {}

	for i in range(1, 10):
		red[Vector2i(randi_range(0, COLS - 1), randi_range(0, ROWS - 1))] = i
	for i in range(1, 10):
		green[Vector2i(randi_range(0, COLS - 1), randi_range(0, ROWS - 1))] = i
	for i in range(1, 10):
		blue[Vector2i(randi_range(0, COLS - 1), randi_range(0, ROWS - 1))] = i

	return [red, green, blue]

func get_neighbor_slots(loc: Vector2i, radius: int = 1) -> Array[Slot]:
	var res: Array[Slot] = []
	if radius < 1:
		return res
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var nloc = Vector2i(loc.x + x, loc.y + y)
			if nloc == loc or nloc.x < 0 or nloc.y < 0 or nloc.x >= COLS or nloc.y >= ROWS:
				continue
			res.append(slot_cache.get(nloc))
	return res

func _new_game() -> void:
	get_tree().call_group(GROUP_SLOTS, "reset")

	var ores: Array[Dictionary] = get_ore_map()
	for i in ores[0].keys():
		slot_cache.get(i).add_ore(ores[0].get(i), 0, 0)
	for i in ores[1].keys():
		slot_cache.get(i).add_ore(0, ores[1].get(i), 0)
	for i in ores[2].keys():
		slot_cache.get(i).add_ore(0, 0, ores[2].get(i))

	slot_cache.get(Vector2i(1,1)).add_ore(1, 0, 0)
	slot_cache.get(Vector2i(1,2)).add_ore(0, 2, 0)
	slot_cache.get(Vector2i(1,3)).add_ore(0, 0, 3)

	get_tree().call_group(GROUP_SLOTS, "_update_debug")

func _ready() -> void:
	get_tree().call_group.call_deferred(GROUP_SLOTS, "init_main", self)
	_new_game.call_deferred()


func _process(_delta: float) -> void:
	pass

extends Node2D
class_name Main

const GROUP_SLOTS = "slots"
const ROWS = 15
const COLS = 15

var slot_cache: Dictionary[Vector2i, Slot] = {}

var target_red: int = 0:
	set(x):
		target_red = x
		if not target_red_failed:
			%red_target.text = str(x)
var target_green: int = 0:
	set(x):
		target_green = x
		if not target_green_failed:
			%green_target.text = str(x)
var target_blue: int = 0:
	set(x):
		target_blue = x
		if not target_blue_failed:
			%blue_target.text = str(x)
var target_red_failed: bool = false
var target_green_failed: bool = false
var target_blue_failed: bool = false


func get_ore_map() -> Array[Dictionary]:
	var red: Dictionary[Vector2i, int] = {}
	var green: Dictionary[Vector2i, int] = {}
	var blue: Dictionary[Vector2i, int] = {}

	var coords = []
	for i in range(0, COLS - 1):
		for j in range(0, ROWS - 1):
			coords.append(Vector2i(i, j))
	coords.shuffle()

	for i in range(1, 10):
		red[coords[i - 1]] = i
	for i in range(1, 10):
		green[coords[i - 1 + 10]] = i
	for i in range(1, 10):
		blue[coords[i - 1 + 20]] = i

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

func rclick(loc:Vector2i, pos: Vector2, cantOpen: bool) -> void:
	if %rclick.visible:
		%rclick.visible = false
	elif not cantOpen:
		%rclick.open_menu(self, loc, pos + Vector2(26,26))

func flag_slot(loc: Vector2i, r: int, g: int, b: int) -> void:
	#Loggie.info(loc, r, g, b)
	var s = slot_cache.get(loc) as Slot
	s.flag_slot(r, g, b)

func handle_revealed_ore(r: int, g: int, b: int) -> void:
	#Loggie.info(r, g, b, target_red, target_green, target_blue)
	if r != 0:
		if r - 1 == target_red:
			target_red = r
		else:
			target_red_failed = true
			%red_target.text = "X"
	if g != 0:
		if g - 1 == target_green:
			target_green = g
		else:
			target_green_failed = true
			%green_target.text = "X"
	if b != 0:
		if b - 1 == target_blue:
			target_blue = b
		else:
			target_blue_failed = true
			%blue_target.text = "X"

func is_flag_ready(r: int, g: int, b: int) -> bool:
	return (r == 0 or r - 1 == target_red) and \
		(g == 0 or g - 1 == target_green) and \
		(b == 0 or b - 1 == target_blue)

func _new_game() -> void:
	Loggie.info("new_game")
	get_tree().call_group(GROUP_SLOTS, "reset")
	%rclick.visible = false

	# need to reset failed before value
	target_red_failed = false
	target_green_failed = false
	target_blue_failed = false
	target_red = 0
	target_green = 0
	target_blue = 0

	var ores: Array[Dictionary] = get_ore_map()
	for i in ores[0].keys():
		slot_cache.get(i).add_ore(ores[0].get(i), 0, 0)
	for i in ores[1].keys():
		slot_cache.get(i).add_ore(0, ores[1].get(i), 0)
	for i in ores[2].keys():
		slot_cache.get(i).add_ore(0, 0, ores[2].get(i))

	get_tree().call_group(GROUP_SLOTS, "_update_debug")

func _ready() -> void:
	get_tree().call_group.call_deferred(GROUP_SLOTS, "init_main", self)
	_new_game.call_deferred()

func _process(_delta: float) -> void:
	pass

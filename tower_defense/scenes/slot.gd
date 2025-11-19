extends Node2D
class_name Slot

const SLOT = preload("uid://btxy6u16uicq1")

var world: World
var loc: Vector2i

var is_goal: bool = false
var is_spawner: bool = false
var is_turret: bool = false

func setup_goal() -> void:
	is_goal = true
	$goal.visible = true

func setup_spawner() -> void:
	is_spawner = true
	$spawner.visible = true

func add_turret() -> void:
	is_turret = true
	$turret.visible = true

func remove_turret() -> void:
	is_turret = false
	$turret.visible = false

static func instantiate(w: World, l: Vector2i, isGoal: bool, isSpawner: bool) -> Slot:
	var s: Slot = SLOT.instantiate() as Slot
	s.world = w
	s.position = l * Globals.SLOT_SIZE
	s.loc = l
	if isGoal:
		s.setup_goal()
	if isSpawner:
		s.setup_spawner()
	return s

func is_passable() -> bool:
	return !is_turret

func is_buildable() -> bool:
	if is_goal or is_spawner:
		return false
	return true

func _update_debug() -> void:
	$debug.text = str(
		"g: ", goal_distance, "\n",
		"d: ", goal_direction, "\n",
	)

# goal pathfinding

var goal_distance: int = -1
var goal_direction: Vector2i = Vector2i.ZERO
static func update_all_paths() -> void:
	var nodes = Engine.get_main_loop().get_nodes_in_group(Globals.GROUP_SLOTS) as Array[Slot]
	for s: Slot in nodes:
		s.goal_direction = Vector2i.ZERO
		s.goal_distance = -1
	var slot_queue: Array[Slot] = []
	var dist_map: Dictionary[Vector2i, int] = {}
	var dir_map: Dictionary[Vector2i, Vector2i] = {}
	for s: Slot in nodes:
		if s.is_goal:
			slot_queue.append(s)
			dist_map.set(s.loc, 0)
			dir_map.set(s.loc, Vector2i.ZERO)
	_update_queue(slot_queue, dist_map, dir_map)
	for s: Slot in nodes:
		s._update_debug()
static func _update_queue(
	slot_queue: Array[Slot],
	dist_map: Dictionary[Vector2i, int],
	dir_map: Dictionary[Vector2i, Vector2i]
) -> bool:
	while slot_queue.size() != 0:
		var s = slot_queue.pop_front()
		s.goal_distance = dist_map.get(s.loc)
		s.goal_direction = dir_map.get(s.loc)
		var ns = _get_neighbors(s.loc)
		for n: Slot in ns.keys():
			if !dist_map.has(n.loc) or s.goal_distance + 1 < dist_map.get(n.loc):
				if !slot_queue.has(n):
					slot_queue.push_back(n)
				dist_map.set(n.loc, s.goal_distance + 1)
				dir_map.set(n.loc, ns.get(n))
	return false
static func _get_neighbors(loca: Vector2i) -> Dictionary[Slot, Vector2i]:
	var results: Dictionary[Slot, Vector2i] = {}
	var up = World.instance.getSlotAt(loca + Vector2i.UP)
	var p_up = up != null && up.is_passable()
	var down = World.instance.getSlotAt(loca + Vector2i.DOWN)
	var p_down = down != null && down.is_passable()
	var left = World.instance.getSlotAt(loca + Vector2i.LEFT)
	var p_left = left != null && left.is_passable()
	var right = World.instance.getSlotAt(loca + Vector2i.RIGHT)
	var p_right = right != null && right.is_passable()

	if p_up:
		results.set(up, Vector2i.UP)
	if p_down:
		results.set(down, Vector2i.DOWN)
	if p_left:
		results.set(left, Vector2i.LEFT)
	if p_right:
		results.set(right, Vector2i.RIGHT)

	if p_up and p_left:
		var ul = World.instance.getSlotAt(loca + Vector2i.UP + Vector2i.LEFT)
		if ul != null && ul.is_passable():
			results.set(ul, Vector2i.UP + Vector2i.LEFT)
	if p_up and p_right:
		var ur = World.instance.getSlotAt(loca + Vector2i.UP + Vector2i.RIGHT)
		if ur != null and ur.is_passable():
			results.set(ur, Vector2i.UP + Vector2i.RIGHT)
	if p_down and p_left:
		var dl = World.instance.getSlotAt(loca + Vector2i.DOWN + Vector2i.LEFT)
		if dl != null && dl.is_passable():
			results.set(dl, Vector2i.DOWN + Vector2i.LEFT)
	if p_down and p_right:
		var dr = World.instance.getSlotAt(loca + Vector2i.DOWN + Vector2i.RIGHT)
		if dr != null and dr.is_passable():
			results.set(dr, Vector2i.DOWN + Vector2i.RIGHT)

	return results

func on_click() -> void:
	if is_buildable():
		if is_turret:
			remove_turret()
			Slot.update_all_paths()
		else:
			add_turret()
			Slot.update_all_paths()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Frame.width = Globals.SLOT_SIZE
	$Frame.height = Globals.SLOT_SIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			on_click()

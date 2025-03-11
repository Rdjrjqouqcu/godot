extends Node

var radius: int = 3
var expand_pct: float = 0.5

# debug values
var board_available: float = 0

const unit_length: int = 128
const score_timeout: float = 0.75
const SLOT = preload("res://slot.tscn")
const SCORE_HIGHLIGHT = preload("res://score_highlight.tscn")

@onready var debug: Label = %debug
@onready var radius_option: OptionButton = %radiusOption
@onready var expand_option: OptionButton = %expandOption
@onready var slots_node: Node = %slots
@onready var sh: ScoreHighlight = $score_highlight
@onready var st: Timer = $score_timer

var slots: Dictionary[Vector2i, Slot] = {}
var npc_modes: Dictionary[int, Callable] = {}
var npc_mode_names: Dictionary[int, String] = {}

var turn: int = 0
var enabled_radius: int = 1

var p1_selected: Vector2i = Vector2i(0, 0)
var p2_selected: Vector2i = Vector2i(0, 0)
var p3_selected: Vector2i = Vector2i(0, 0)

var p1_move: Variant = null
var p2_move: Variant = null
var p3_move: Variant = null

class ScoreEvent:
	var player: int
	var value: int
	var left: Vector2i
	var right: Vector2i
	func init(p: int, v: int, l: Vector2i, r: Vector2i) -> void:
		player = p
		value = v
		left = l
		right = r
var score_queue: Array[ScoreEvent] = []

var p1_score: int = 0
var p2_score: int = 0
var p3_score: int = 0

func _score_queue_pop() -> void:
	if score_queue.size() == 0:
		sh.hide_all()
		return

	var item = score_queue.pop_front() as ScoreEvent
	var color: Color
	if item.player == 1:
		p1_score += item.value
		color = Constants.colors[p1_selected.y]
	elif item.player == 2:
		p2_score += item.value
		color = Constants.colors[p2_selected.y]
	elif item.player == 3:
		p3_score += item.value
		color = Constants.colors[p3_selected.y]

	if color != null:
		sh.display(item.left, item.right, color)

	# restart regardless to hide the last view
	_update_debug()
	st.start(score_timeout)

func _score_queue_add(player: int, value: int, left: Vector2i, right: Vector2i) -> void:
	#print("ScoreQueueAdded: ", player, " ", left, " ", right, " ", value)
	var entry = ScoreEvent.new()
	entry.init(player, value, left, right)
	score_queue.append(entry)
	if st.is_stopped():
		st.start(score_timeout)
		_score_queue_pop()

func _do_score_horizontal_slot_map(center: Vector2i, offset: int) -> Slot:
	if abs(center.x + offset) > radius:
		return null
	return slots[Vector2i(center.x + offset, center.y)] as Slot
func _do_score_vertical_slot_map(center: Vector2i, offset: int) -> Slot:
	if abs(center.y + offset) > radius:
		return null
	return slots[Vector2i(center.x, center.y + offset)] as Slot
func _do_score_slash_slot_map(center: Vector2i, offset: int) -> Slot:
	if abs(center.x + offset) > radius:
		return null
	if abs(center.y + offset) > radius:
		return null
	return slots[Vector2i(center.x + offset, center.y + offset)] as Slot
func _do_score_backslash_slot_map(center: Vector2i, offset: int) -> Slot:
	if abs(center.x + offset) > radius:
		return null
	if abs(center.y - offset) > radius:
		return null
	return slots[Vector2i(center.x + offset, center.y - offset)] as Slot

func _do_score_line(player: int, center: Vector2i, slot_map: Callable) -> void:
	# find left and right
	var left = 0
	var left_slot = slot_map.call(center, 0) as Slot
	while left_slot.has_player(player):
		left = left - 1
		left_slot = slot_map.call(center, left) as Slot
		if left_slot == null:
			break
	left = left + 1
	left_slot = slot_map.call(center, left) as Slot

	var right = 0
	var right_slot = slot_map.call(center, 0) as Slot
	while right_slot.has_player(player):
		right = right + 1
		right_slot = slot_map.call(center, right) as Slot
		if right_slot == null:
			break
	right = right - 1
	right_slot = slot_map.call(center, right) as Slot

	#print("l/r: ", Vector2i(left, right))

	# add scores
	for x in range(left, 1, 1):
		for y in range(right, -1, -1):
			var count = y - x + 1
			if count < 3:
				continue
			_score_queue_add(player, count - 2, (slot_map.call(center, x) as Slot).loc, (slot_map.call(center, y) as Slot).loc)

func _do_score(player: int, move: Vector2i) -> void:
	#var tween = get_tree().create_tween()
	
	if (slots[move] as Slot).is_overloaded():
		return

	#print("player=", player, " move=", move)

	_do_score_line(player, move, _do_score_horizontal_slot_map)
	_do_score_line(player, move, _do_score_vertical_slot_map)
	_do_score_line(player, move, _do_score_slash_slot_map)
	_do_score_line(player, move, _do_score_backslash_slot_map)

func _do_moves() -> void:
	for i in [p1_move, p2_move, p3_move]:
		var s: Slot = slots[i]
		s.play(p1_move == i, p2_move == i, p3_move == i, p1_selected, p2_selected, p3_selected)
	_do_score(1, p1_move)
	_do_score(2, p2_move)
	_do_score(3, p3_move)
	#sh.display(p1_move, p3_move, Constants.colors[p1_selected.y])
	var enabled_count = 0
	var playable_count = 0
	for s: Slot in slots.values():
		enabled_count += 1 if s.enabled else 0
		playable_count += 1 if s.is_playable() else 0
	board_available = 1.0 * playable_count / enabled_count
	print(playable_count, " ", enabled_count, " ", (1.0 * playable_count / enabled_count))
	if 1.0 * playable_count / enabled_count < expand_pct:
		if enabled_radius < radius:
			enabled_radius += 1
			_enable_radius()
		elif playable_count == 0:
			print("TODO: Board full.")

func _on_slot_clicked(loc: Vector2i) -> void:
	var s: Slot = slots[loc]
	sh.hide_all()
	if not s.is_playable():
		return
	if turn == 0:
		p1_move = loc
		turn += 1
		if %mode2.selected != 0:
			p2_move = npc_modes[%mode2.selected].call()
			turn += 1
			if %mode3.selected != 0:
				p3_move = npc_modes[%mode3.selected].call()
				turn += 1
	elif turn == 1:
		p2_move = loc
		turn += 1
		if %mode3.selected != 0:
			p3_move = npc_modes[%mode3.selected].call()
			turn += 1
	elif turn == 2:
		p3_move = loc
		turn += 1
	if turn == 3:
		turn = 0
		_do_moves()
	_update_debug()

func _update_debug() -> void:
	debug.text = str(
		"dims: ", (2*radius+1), "x", (2*radius+1), "\n",
		"radius: ", enabled_radius, "/", radius, "\n",
		"expand: ", board_available, "/", expand_pct, "\n",
		"moves(", turn, "): ", p1_move, " ", p2_move, " ", p3_move, "\n",
		"score: ", p1_score, " ", p2_score, " ", p3_score, "\n",
	)

func _enable_radius() -> void:
	for i in range(-enabled_radius, enabled_radius + 1):
		for j in range(-enabled_radius, enabled_radius + 1):
			slots[Vector2i(i, j)].enable()

func restart_game() -> void:
	radius = 3 + radius_option.selected
	expand_pct = 1 - (3 + expand_option.selected) / 10.0
	board_available = 0
	slots = {}
	turn = 0
	enabled_radius = 1
	p1_move = null
	p2_move = null
	p3_move = null
	st.stop()
	score_queue = []
	p1_score = 0
	p2_score = 0
	p3_score = 0
	
	var s1 = %shape1.get_selected_id()
	var s2 = %shape2.get_selected_id()
	var s3 = %shape3.get_selected_id()
	var c1 = %color1.get_selected_id()
	var c2 = %color2.get_selected_id()
	var c3 = %color3.get_selected_id()
	p1_selected = Vector2i(s1, c1)
	p2_selected = Vector2i(s2, c2)
	p3_selected = Vector2i(s3, c3)
	
	for slot in slots_node.get_children():
		slot.queue_free()
	
	var center: Vector2 = Vector2(unit_length * radius, unit_length * (radius + 1))
	for i in range(-radius, radius+1):
		for j in range(-radius, radius+1):
			var loc = Vector2i(i, j)
			var s = SLOT.instantiate()
			s.init(loc, _on_slot_clicked, center, unit_length)
			slots[loc] = s
			slots_node.add_child(s)
	_enable_radius()
	var window = get_window()
	window.size = 0.75 * Vector2i((2 * radius + 1) * unit_length, (2 * radius + 2) * unit_length)
	window.unresizable = true
	_update_debug()
	
	sh.init(center, unit_length)

func _move_random() -> Vector2i:
	var available = []
	for s: Slot in slots.values():
		if s.is_playable():
			available.append(s.loc)
	if available.size() == 0:
		return Vector2i(0,0)
	return available[randi() % available.size()]

func _add_player_modes() -> void:
	npc_modes[1] = _move_random
	npc_mode_names[1] = "random"
	for m in [ %mode1, %mode2, %mode3 ]:
		m.add_item("random")

func _ready() -> void:
	_add_player_modes()
	restart_game()
	restart_game()

func _process(_delta: float) -> void:
	pass

func _on_restart_pressed() -> void:
	restart_game()

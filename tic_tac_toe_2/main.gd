extends Node

var radius: int = 3
var expand_pct: float = 0.5

# debug values
var board_available: float = 0

const unit_length: int = 128
const SLOT = preload("res://slot.tscn")
const SCORE_HIGHLIGHT = preload("res://score_highlight.tscn")

@onready var debug: Label = %debug
@onready var radius_option: OptionButton = %radiusOption
@onready var expand_option: OptionButton = %expandOption
@onready var slots_node: Node = %slots
@onready var sh: ScoreHighlight = $score_highlight


# v4.4 var slots: Dictionary[Vector2i, Slot] = {}
var slots: Dictionary = {}

var turn: int = 0
var enabled_radius: int = 1

var p1_selected: Vector2i = Vector2i(0, 0)
var p2_selected: Vector2i = Vector2i(0, 0)
var p3_selected: Vector2i = Vector2i(0, 0)

var p1_move: Variant = null
var p2_move: Variant = null
var p3_move: Variant = null

func _do_moves() -> void:
	for i in [p1_move, p2_move, p3_move]:
		var s: Slot = slots[i]
		s.play(p1_move == i, p2_move == i, p3_move == i, p1_selected, p2_selected, p3_selected)
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
	match turn:
		0:
			p1_move = loc
		1:
			p2_move = loc
		2:
			p3_move = loc
	turn += 1
	if turn == 3:
		turn = 0
		sh.display(p1_move, p3_move, Constants.colors[p1_selected.y])
		_do_moves()
	_update_debug()

func _update_debug() -> void:
	debug.text = str(
		"dims: ", (2*radius+1), "x", (2*radius+1), "\n",
		"radius: ", enabled_radius, "/", radius, "\n",
		"expand: ", board_available, "/", expand_pct, "\n",
		"moves(", turn, "): ", p1_move, " ", p2_move, " ", p3_move, "\n",
		"score: ", 0, " ", 0, " ", 0, "\n",
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
	window.size = Vector2i((2 * radius + 1) * unit_length, (2 * radius + 2) * unit_length)
	window.unresizable = true
	_update_debug()
	
	sh.init(center, unit_length)

func _ready() -> void:
	restart_game()
	restart_game()

func _process(_delta: float) -> void:
	pass

func _on_restart_pressed() -> void:
	restart_game()

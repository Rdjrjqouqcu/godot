extends Node2D
@onready var state = %State

const SLOT = preload("res://slot.tscn")
const FLOATING_TEXT = preload("res://floating_text.tscn")

signal played(x, y)
var board = Array()

@export var x_turn = true

func b_idx(x, y):
	return (x + RADIUS)  + WIDTH * (y + RADIUS)

func next_turn():
	x_turn = not x_turn
	return not x_turn


const RADIUS = 4
const WIDTH = 2 * RADIUS + 1
var left = 0
var right = 0
var top = 0
var bottom = 0

const colors = [
	Color.RED,
	Color.ORANGE,
	Color.YELLOW,
	Color.GREEN,
	Color.BLUE,
	Color.INDIGO,
	Color.VIOLET,
]

var x_color
var o_color

func _ready():
	played.connect(on_played)
	add_slot(0, 0)
	board.resize(0)
	get_window().size = Vector2i(128 * (WIDTH + 2), 128 * (WIDTH + 2))
	board.resize(WIDTH * WIDTH)
	x_color = colors[randi() % colors.size()]
	o_color = colors[randi() % colors.size()]

func on_played(x, y, turn):
	board[b_idx(x, y)] = turn
	update_score(x, y, turn)
	handle_adding_slots(x, y)

func update_score(x, y, t):
	print("update ", x, " ", y, " ", t)
	check_score_horizontal(x, y, t)
	check_score_vertical(x, y, t)
	check_score_slash(x, y, t)
	check_score_backslash(x, y, t)

# n in a row score  0  1  2  3  4  5  6  7  8  9
const SCORE_MAP = [ 0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
#const SCORE_MAP = [ 0, 0, 0, 1, 2, 3, 4, 5, 6, 7]

func add_score(s, shape, t, x0, y0, x1, y1):
	print("score: ", shape, " ", s , " ", Vector2i(x0, y0), " ", Vector2i(x1, y1))
	if s == 0:
		return
	var txt = FLOATING_TEXT.instantiate()
	txt.text = shape + " " + str(s)
	#txt.duration = 1.0
	txt.m_position(Vector2i(x0 * 128 - 64, y0 * 128 - 64), Vector2i(x1 * 128 - 64, y1 * 128 - 64))
	txt.start()
	pass # TODO add score over time

func check_score_horizontal(x, y, t):
	var x_count = 1
	var x_min = x
	var x_max = x
	for i in range(x + 1, right + 1):
		if board[b_idx(i, y)] == t:
			x_count += 1
			x_max = i
		else:
			break
	for i in range(x - 1, left - 1, -1):
		if board[b_idx(i, y)] == t:
			x_count += 1
			x_min = i
		else:
			break
	add_score(SCORE_MAP[x_count], "-", t, x_min, y, x_max, y)

func check_score_vertical(x, y, t):
	var y_count = 1
	var y_min = x
	var y_max = x
	for i in range(y + 1, bottom + 1):
		if board[b_idx(x, i)] == t:
			y_count += 1
			y_max = i
		else:
			break
	for i in range(y - 1, top - 1, -1):
		if board[b_idx(x, i)] == t:
			y_count += 1
			y_min = i
		else:
			break
	add_score(SCORE_MAP[y_count], "|", t, x, y_min, x, y_max)

func check_score_slash(x, y, t):
	var d_count = 1
	var d_min = 0
	var d_max = 0
	for i in range(1, min(right + 1 - x, bottom + 1 - y)):
		if board[b_idx(x+i, y+i)] == t:
			d_count += 1
			d_max = i
		else:
			break
	for i in range(-1, max(left - 1 + x, top - 1 + y), -1):
		if board[b_idx(x + i, y + i)] == t:
			d_count += 1
			d_min = i
		else:
			break
	add_score(SCORE_MAP[d_count], "\\", t, x + d_min, y + d_min, x + d_max, y + d_max)

func check_score_backslash(x, y, t):
	var d_count = 1
	var d_min = 0
	var d_max = 0
	for i in range(1, WIDTH):
		if x + i > RADIUS or y - i < -RADIUS:
			break
		if board[b_idx(x + i, y - i)] == t:
			d_count += 1
			d_max = i
		else:
			break
	for i in range(1, WIDTH):
		if x - i < -RADIUS or y + i > RADIUS:
			break
		if board[b_idx(x - i, y + i)] == t:
			d_count += 1
			d_min = i
		else:
			break
	add_score(SCORE_MAP[d_count], "/", t, x - d_min, y + d_min, x + d_max, y - d_max)

func handle_adding_slots(x, y):
	if x == left and left != -RADIUS:
		# add left column
		left -= 1
		for j in range(top,bottom + 1):
			add_slot(left, j)
	if x == right and right != RADIUS:
		# add right column
		right += 1
		for j in range(top,bottom + 1):
			add_slot(right, j)
	if y == top and top != -RADIUS:
		# add top row
		top -= 1
		for i in range(left, right + 1):
			add_slot(i, top)
	if y == bottom and bottom != RADIUS:
		# add bottom row
		bottom += 1
		for i in range(left, right + 1):
			add_slot(i, bottom)

func add_slot(x, y):
	var instance = SLOT.instantiate()
	instance.set_pos(x, y)
	instance.set_colors(x_color, o_color)
	instance.gs = self
	instance.sig = played
	add_child(instance)



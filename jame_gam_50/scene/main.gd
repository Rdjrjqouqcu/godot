extends Node2D
class_name Main

const FRAME = preload("res://scene/meta/frame.tscn")

var started: bool = false
var start_delay = 50
var collected_chips = 0
var total_chips = 10
var completed_mega_chip = false
var remaining_population = 100_000_000
var time_elapsed_ms = 0
var circuit_cooldown_ms = 500
var puzzle_cooldown_ms = 0
var board: Dictionary[Vector2i, bool] = {}
var active_puzzle_count: int = 0
var is_circuit_active: bool = false

const spawn_fail_cooldown_ms = 10
const mult_per_10s_pop_damage = 1.5
const mult_overall_cooldown = 2.0
const mult_per_10s_cooldown = 0.9
const debug_info: bool = false

func _comma_format(i: int) -> String:
	var text = ""
	while i >= 1000:
		text += ",%03d" % (i % 1000)
		i /= 1000
	return str(i, text)
func _modify_cooldowns(c: int) -> int:
	return c * mult_overall_cooldown * (mult_per_10s_cooldown ** (time_elapsed_ms / 100.0 / 10.0))
func _rand_coords() -> Vector2i:
	return Vector2i(randi_range(0,15), randi_range(0,8))
func _init_frames() -> void:
	for i in range(16):
		for j in range(9):
			var frame = FRAME.instantiate()
			frame.pos = Vector2i(i, j)
			frame.global_position = Vector2i(i*120, j * 120)
			$frames.add_child(frame)
func _end_game():
	started = false
	for c in get_puzzle_node().get_children():
		c.queue_free()
	%timeDisplayFin.text = %timeDisplay.text
	%popDisplayFin.text = %popDisplay.text
	%chipDisplayFin.text = %chipDisplay.text
	%chipMegaFin.text = str(1 if completed_mega_chip else 0, " / ", 1)
	$scores.visible = false
	$endScreen.visible = true

const total_puzzles = 18
func _get_noncirc_puzzle() -> PuzzleBase:
	#return PuzzleInit.get_new_red()
	var r = randi_range(0, total_puzzles - 1)
	r -= 6
	if r < 0:
		return PuzzleInit.get_new_green()
	r -= 2
	if r < 0:
		return PuzzleInit.get_new_green2()
	r -= 3
	if r < 0:
		return PuzzleInit.get_new_blue()
	r -= 1
	if r < 0:
		return PuzzleInit.get_new_blue2()
	r -= 3
	if r < 0:
		return PuzzleInit.get_new_red()
	r -= 3
	if r < 0:
		return PuzzleInit.get_new_meteor()
	Loggie.error("Random Puzzle selection failed using default: ", r)
	return PuzzleInit.get_new_green()

func _on_start_pressed() -> void:
	started = true
	$startMenu.visible = false
func _on_restart_pressed() -> void:
	$endScreen.visible = false
	$startMenu.visible = true
	$scores.visible = true
	started = false

func get_puzzle_node() -> Node:
	return $puzzles
func mark_add_puzzle(locs: Array[Vector2i], is_circuit: bool, spawn_cooldown: int):
	active_puzzle_count += 1
	is_circuit_active = is_circuit_active || is_circuit
	if is_circuit && spawn_cooldown >= 0:
		circuit_cooldown_ms = _modify_cooldowns(spawn_cooldown)
	if !is_circuit && spawn_cooldown >= 0:
		puzzle_cooldown_ms = _modify_cooldowns(spawn_cooldown)
	for loc in locs:
		board.set(loc, true)
func mark_free_puzzle(locs: Array[Vector2i], is_circuit: bool, spawn_cooldown: int):
	active_puzzle_count -= 1
	is_circuit_active = is_circuit_active && !is_circuit
	if is_circuit && spawn_cooldown >= 0:
		circuit_cooldown_ms = _modify_cooldowns(spawn_cooldown)
	if !is_circuit && spawn_cooldown >= 0:
		puzzle_cooldown_ms = _modify_cooldowns(spawn_cooldown)
	for loc in locs:
		board.set(loc, false)
func add_circuit() -> void:
	collected_chips += 1
	_redraw_text()
func add_mega_circuit() -> void:
	completed_mega_chip = true
	_redraw_text()
	_end_game()
func lose_population(amount: int):
	var final_amount = amount * (mult_per_10s_pop_damage ** (time_elapsed_ms / 100.0 / 10.0) )
	remaining_population -= final_amount
	if remaining_population < 0:
		remaining_population = 0
	_redraw_text()
	if remaining_population == 0:
		_end_game()

func _redraw_text() -> void:
	%popDisplay.text = _comma_format(remaining_population)
	%chipDisplay.text = str(collected_chips, " / ", total_chips)
	var text = ""
	@warning_ignore("integer_division")
	var tmin:int = time_elapsed_ms / 60 / 100
	@warning_ignore("integer_division")
	var sec:int = floori(time_elapsed_ms / 100) % 60
	var ms:int = floori(time_elapsed_ms) % 100
	%timeDisplay.text = "%02d:%02d.%02d" % [tmin, sec, ms]
	for child in $frames.get_children():
		child.redraw(board)

func _spawn_circuit_puzzle() -> bool:
	var c = _rand_coords()
	var p: PuzzleCircuit
	if collected_chips == total_chips:
		p = PuzzleCircuit.get_new_mega()
	else:
		p = PuzzleCircuit.get_new()
	for i in range(10):
		if p.can_fit(c, board):
			break
		c = _rand_coords()
	if p.can_fit(c, board):
		p.init(c, self)
		return true
	return false
func _spawn_noncirc_puzzle() -> bool:
	var c = _rand_coords()
	var p = _get_noncirc_puzzle()
	for i in range(10):
		if p.can_fit(c, board):
			break
		c = _rand_coords()
	if p.can_fit(c, board):
		p.init(c, self)
		return true
	return false

func _ready() -> void:
	seed(0)
	for i in range(0, 16):
		for j in range(0, 9):
			board.set(Vector2i(i, j), false)
	_init_frames()
	$frames.visible = debug_info
	board.set(Vector2i(0, 0), true)
	board.set(Vector2i(1, 0), true)
	board.set(Vector2i(2, 0), true)
	_redraw_text()

func _process(delta: float) -> void:
	if !started:
		return
	if start_delay >= 0:
		start_delay -= delta * 100
		return

	time_elapsed_ms += delta * 100
	circuit_cooldown_ms -= delta * 100
	puzzle_cooldown_ms -= delta * 100
	_redraw_text()

	if circuit_cooldown_ms <= 0:
		if !is_circuit_active:
			if _spawn_circuit_puzzle():
				return
			circuit_cooldown_ms = spawn_fail_cooldown_ms
			#Loggie.info("circuit spawn failed")
	if puzzle_cooldown_ms <= 0:
		if _spawn_noncirc_puzzle():
			return
		puzzle_cooldown_ms = spawn_fail_cooldown_ms
		#Loggie.info("puzzle spawn failed")

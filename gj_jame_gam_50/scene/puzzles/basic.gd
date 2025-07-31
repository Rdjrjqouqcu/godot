extends PuzzleBase
class_name PuzzleInit

const GREEN = preload("res://scene/puzzles/shield_1x1.tscn")
const BLUE = preload("res://scene/puzzles/shield_blue_1x1.tscn")
const RED = preload("res://scene/puzzles/shield_red_1x1.tscn")
const GREEN2 = preload("res://scene/puzzles/shield_2x2.tscn")
const BLUE2 = preload("res://scene/puzzles/shield_blue_2x2.tscn")

const METEOR = preload("res://scene/puzzles/meteor_2x_1.tscn")

static func get_new_green() -> PuzzleBase:
	var puzzle = GREEN.instantiate()
	puzzle.spawn_cooldown_min = 25
	puzzle.spawn_cooldown_max = 50
	puzzle.pop_loss_min = 1_000
	puzzle.pop_loss_max = 5_000
	return puzzle

static func get_new_blue() -> PuzzleBase:
	var puzzle = BLUE.instantiate()
	puzzle.spawn_cooldown_min = 25
	puzzle.spawn_cooldown_max = 50
	puzzle.pop_loss_min = 1_000
	puzzle.pop_loss_max = 5_000
	return puzzle

static func get_new_red() -> PuzzleBase:
	var puzzle = RED.instantiate()
	puzzle.spawn_cooldown_min = 25
	puzzle.spawn_cooldown_max = 50
	puzzle.pop_loss_min = 1_000
	puzzle.pop_loss_max = 5_000
	return puzzle

static func get_new_green2() -> PuzzleBase:
	var puzzle = GREEN2.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0), Vector2i(0,1), Vector2i.ONE] as Array[Vector2i]
	puzzle.spawn_cooldown_min = 100
	puzzle.spawn_cooldown_max = 200
	puzzle.pop_loss_min = 50_000
	puzzle.pop_loss_max = 250_000
	return puzzle

static func get_new_blue2() -> PuzzleBase:
	var puzzle = BLUE2.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0), Vector2i(0,1), Vector2i.ONE] as Array[Vector2i]
	puzzle.spawn_cooldown_min = 75
	puzzle.spawn_cooldown_max = 150
	puzzle.pop_loss_min = 50_000
	puzzle.pop_loss_max = 250_000
	return puzzle

static func get_new_meteor() -> PuzzleBase:
	var puzzle = METEOR.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(0,1)] as Array[Vector2i]
	puzzle.spawn_cooldown_min = 75
	puzzle.spawn_cooldown_max = 150
	puzzle.pop_loss_min = 50_000
	puzzle.pop_loss_max = 250_000
	return puzzle

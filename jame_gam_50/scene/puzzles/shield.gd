extends PuzzleBase
class_name PuzzleShield

const GREEN = preload("res://scene/puzzles/shield_1x1.tscn")
const BLUE = preload("res://scene/puzzles/shield_blue_1x1.tscn")
const GREEN2 = preload("res://scene/puzzles/shield_2x2.tscn")
const BLUE2 = preload("res://scene/puzzles/shield_blue_2x2.tscn")

static func get_new_green() -> PuzzleShield:
	var puzzle = GREEN.instantiate()
	puzzle.spawn_cooldown_min = 25
	puzzle.spawn_cooldown_max = 50
	return puzzle

static func get_new_blue() -> PuzzleShield:
	var puzzle = BLUE.instantiate()
	puzzle.spawn_cooldown_min = 25
	puzzle.spawn_cooldown_max = 50
	return puzzle

static func get_new_green2() -> PuzzleShield:
	var puzzle = GREEN2.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0), Vector2i(0,1), Vector2i.ONE] as Array[Vector2i]
	puzzle.spawn_cooldown_min = 100
	puzzle.spawn_cooldown_max = 200
	return puzzle

static func get_new_blue2() -> PuzzleShield:
	var puzzle = BLUE2.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0), Vector2i(0,1), Vector2i.ONE] as Array[Vector2i]
	puzzle.spawn_cooldown_min = 75
	puzzle.spawn_cooldown_max = 150
	return puzzle

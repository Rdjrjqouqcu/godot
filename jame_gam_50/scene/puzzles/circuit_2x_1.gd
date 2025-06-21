extends PuzzleBase
class_name PuzzleCircuit2x1

const CIRCUIT_2X_1 = preload("res://scene/puzzles/circuit_2x_1.tscn")

static func get_new() -> PuzzleCircuit2x1:
	var puzzle = CIRCUIT_2X_1.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0)] as Array[Vector2i]
	puzzle.is_circuit = true
	puzzle.complete_cooldown_min = 500
	puzzle.complete_cooldown_max = 1000
	puzzle.pop_loss_min = 0
	puzzle.pop_loss_max = 0
	return puzzle

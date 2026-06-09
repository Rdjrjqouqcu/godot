extends PuzzleBase
class_name PuzzleCircuit

const CIRCUIT = preload("res://scene/puzzles/circuit.tscn")
const CIRCUIT_MEGA = preload("res://scene/puzzles/circuit_mega.tscn")

static func get_new() -> PuzzleCircuit:
	var puzzle = CIRCUIT.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0)] as Array[Vector2i]
	puzzle.is_circuit = true
	puzzle.complete_cooldown_min = 4_00
	puzzle.complete_cooldown_max = 1_00
	puzzle.pop_loss_min = 0
	puzzle.pop_loss_max = 0
	return puzzle

static func get_new_mega() -> PuzzleCircuit:
	var puzzle = CIRCUIT_MEGA.instantiate()
	puzzle.offsets = [Vector2i.ZERO, Vector2i(1,0), Vector2i(2,0), Vector2i(3,0),
					 Vector2i(0,1), Vector2i(1,1), Vector2i(2,1), Vector2i(3,1)] as Array[Vector2i]
	puzzle.is_mega_circuit = true
	puzzle.complete_cooldown_min = 4_00
	puzzle.complete_cooldown_max = 4_00
	puzzle.pop_loss_min = 0
	puzzle.pop_loss_max = 0
	return puzzle

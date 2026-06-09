extends PuzzleBase
class_name PuzzleCircuit2x1

const CIRCUIT_2X_1 = preload("res://scene/puzzles/circuit_2x_1.tscn")
@onready var fail_timer: FailTimer = $failTimer

static func create_circuit_2x1(location: Vector2i) -> PuzzleCircuit2x1:
	var puzzle = CIRCUIT_2X_1.instantiate()
	puzzle.position = location * 120
	return puzzle

func pass_puzzle() -> void:
	Loggie.info("pass", self.position / 120)
	queue_free()
	get_parent().add_circuit()
	
func fail_puzzle() -> void:
	Loggie.info("fail", self.position / 120)
	queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

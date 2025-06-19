extends PuzzleBase
class_name PuzzleShield1x1

const SHIELD_1X_1 = preload("res://scene/puzzles/shield_1x1.tscn")
@onready var fail_timer: FailTimer = $failTimer

static func create_shield_1x1(location: Vector2i) -> PuzzleShield1x1:
	var puzzle = SHIELD_1X_1.instantiate()
	puzzle.position = location * 120
	return puzzle

func pass_puzzle() -> void:
	Loggie.info("pass", self.position / 120)
	queue_free()
	
func fail_puzzle() -> void:
	Loggie.info("fail", self.position / 120)
	queue_free()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

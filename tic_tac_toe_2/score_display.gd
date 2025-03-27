extends TextureRect
class_name ScoreDisplay

@onready var score_l: Label = $score
@onready var toast_l: Label = $toast
@onready var turn_l: Label = $turn

var score: int = 0
var turn: bool = false

func add_points(amount: int) -> void:
	pass

func start_turn() -> void:
	turn = true
	
func end_turn() -> void:
	turn = false

func init() -> void:
	score = 0
	pass

func _update_draw() -> void:
	turn_l.set_visible(turn)
	score_l.set_text(str(score) + "  ")
	

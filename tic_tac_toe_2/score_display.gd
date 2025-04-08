extends TextureRect
class_name ScoreDisplay

@onready var score_l: Label = $score
@onready var toast_l: Label = $toast
@onready var turn_l: Label = $turn

@export var starting_player: bool = false

var score: int = 0
var turn: bool = false
var color: Color = Color(1,1,1)
var next_turn: ScoreDisplay

func add_points(amount: int) -> void:
	score += amount
	toast_l.text = "\n+" + str(amount)
	toast_l.set_visible(true)
	_update_draw()

func clear_toast() -> void:
	toast_l.set_visible(false)

func _start_turn() -> void:
	turn = true
	self.set_self_modulate(Color(color, 1.0))
	_update_draw()
	
func end_turn() -> void:
	clear_turn()
	next_turn._start_turn()

func clear_turn() -> void:
	turn = false
	self.set_self_modulate(Color(color, 0.75))
	_update_draw()

func init(pc: Color, nt: ScoreDisplay) -> void:
	score = 0
	turn = starting_player
	next_turn = nt

	color = pc
	self.set_self_modulate(Color(color, 1.0 if turn else 0.75))
	#$score.set_self_modulate(Color(color, 1.0))
	#$toast.set_self_modulate(Color(color, 1.0))
	#$turn.set_self_modulate(Color(color, 1.0))

	toast_l.set_visible(false)
	_update_draw()

func _update_draw() -> void:
	turn_l.set_visible(turn)
	score_l.set_text(str(score) + "  ")
	

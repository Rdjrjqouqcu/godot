extends ProgressBar
class_name FailTimer

const time_move: float = 4.0
const time_red: float = 8.0
const time_green: float = 12.0

@export var time_remaining: float = 12.0

@onready var label: Label = $Label

func _updateProgress() -> void:
	var move = min(4.0, time_remaining)
	var red = 1.0 + (min(0, time_red - time_remaining) / 4.0)
	var green = max(0, (min(time_red, time_remaining) - 4.0) / 4.0)

	#label.text = str(floor(100 * time_remaining), " ", floor(100*move), " ", floor(100*red), " ", floor(100 *green))

	self_modulate = Color(red, green, 0, 1)
	value = move

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_remaining -= delta
	_updateProgress()
	if time_remaining <= 0:
		get_parent().fail_puzzle()

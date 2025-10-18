extends Node2D
class_name Slot

const SLOT = preload("uid://bhg7olykab0v4")

var index: int

static func get_new(i:int) -> Slot:
	var s: Slot = SLOT.instantiate() as Slot
	s.index = i
	return s

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

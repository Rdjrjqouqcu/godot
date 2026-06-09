extends Node2D
class_name Slot

const size: Vector2i = Vector2i(25, 25)

var loc: Vector2i

func _update_debug() -> void:
	$debug.text = str(
		loc
	)

func _ready() -> void:
	_update_debug()


func _process(_delta: float) -> void:
	pass

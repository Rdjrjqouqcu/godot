extends TextureRect
class_name TargetMove

const MOVE_TARGET = preload("res://scene/targets/move_target.tscn")
@onready var count: Label = $count

@export var target_count: int = 0
@export var move_count: float = 0

var complete: Signal

static func create_target(location: Vector2i, tscale: Vector2i, difficulty: int, deplete: Signal) -> TargetMove:
	var target = MOVE_TARGET.instantiate()
	target.position = location
	target.scale = tscale
	target.move_count = 0
	target.target_count = difficulty
	target.complete = deplete
	return target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count.text = str(move_count) + "/" + str(target_count)

func _on_gui_input(event: InputEvent) -> void:\
	if event is InputEventMouseMotion:
		move_count += abs(event.relative.x)
		move_count += abs(event.relative.y)
		count.text = str(int(move_count)) + "/" + str(target_count)
		if move_count >= target_count:
			complete.emit()
			queue_free()

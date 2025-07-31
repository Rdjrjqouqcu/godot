extends TextureRect
class_name TargetMove

const MOVE_TARGET = preload("res://scene/targets/move_target.tscn")
@onready var count: Label = $count
@onready var progress: ProgressBar = $progress

@export var target_count: int = 0
@export var move_count: float = 0

var complete: Signal

static func create_target(location: Vector2i, tsize: Vector2i, difficulty: int, deplete: Signal) -> TargetMove:
	var target = MOVE_TARGET.instantiate()
	target.position = location
	target.size = tsize
	target.move_count = 0
	target.target_count = difficulty
	target.complete = deplete
	return target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count.text = str(move_count) + "/" + str(target_count)
	progress.set_max(target_count)
	progress.set_value(move_count)
	if target_count == 1:
		progress.visible = false

func _on_gui_input(event: InputEvent) -> void:\
	if event is InputEventMouseMotion:
		move_count += abs(event.relative.x)
		move_count += abs(event.relative.y)
		progress.set_value(move_count)
		count.text = str(int(move_count)) + "/" + str(target_count)
		if move_count >= target_count:
			complete.emit()
			queue_free()

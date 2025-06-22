extends TextureRect
class_name TargetNoClick

const NOCLICK_TARGET = preload("res://scene/targets/noclick_target.tscn")
@onready var count: Label = $count
@onready var progress: ProgressBar = $progress

@export var target_count: int = 0
@export var click_count: int = 0

var complete: Signal

static func create_target(location: Vector2i, tsize: Vector2i, difficulty: int, deplete: Signal) -> TargetNoClick:
	var target = NOCLICK_TARGET.instantiate()
	target.position = location
	target.size = tsize
	target.click_count = difficulty
	target.target_count = difficulty
	target.complete = deplete
	return target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count.text = str(click_count) + "/" + str(target_count)
	progress.set_max(target_count)
	progress.set_value(click_count)
	if target_count == 1:
		progress.visible = false

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			click_count -= 1
			progress.set_value(click_count)
			count.text = str(click_count) + "/" + str(target_count)
			if click_count <= 0:
				complete.emit()
				queue_free()
	elif target_count == 1 and event is InputEventMouseMotion:
		if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
			complete.emit()
			queue_free()

extends TextureRect
class_name TargetNoClick

const NOCLICK_TARGET = preload("res://scene/targets/noclick_target.tscn")
@onready var count: Label = $count

@export var target_count: int = 0
@export var click_count: int = 0

var complete: Signal

static func create_target(location: Vector2i, tscale: Vector2i, difficulty: int, deplete: Signal) -> TargetNoClick:
	var target = NOCLICK_TARGET.instantiate()
	target.position = location
	target.scale = tscale
	target.click_count = difficulty
	target.target_count = difficulty
	target.complete = deplete
	return target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	count.text = str(click_count) + "/" + str(target_count)

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			click_count -= 1
			count.text = str(click_count) + "/" + str(target_count)
			if click_count <= 0:
				complete.emit()
				queue_free()

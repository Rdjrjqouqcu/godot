extends Node2D
class_name Slot

const SLOT = preload("uid://btxy6u16uicq1")

static func instantiate(loc: Vector2i) -> Slot:
	var s: Slot = SLOT.instantiate() as Slot
	s.position = loc * Globals.SLOT_SIZE
	return s


func on_click() -> void:
	$turret.visible = !$turret.visible

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Frame.width = Globals.SLOT_SIZE
	$Frame.height = Globals.SLOT_SIZE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			on_click()

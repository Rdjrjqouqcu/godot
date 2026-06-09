extends Node2D
class_name Board

@onready var slots_node: Node2D = $slots

const MARGIN_SIZE: int = 8
const SLOT_SIZE: int = 64

const SLOT_COLUMNS: int = 4
const SLOT_ROWS: int = 8
const SLOT_COUNT: int = SLOT_COLUMNS * SLOT_ROWS


var slots: Array[Slot] = []

func _arrange_board() -> void:
	pass

func _get_slot_position(index: int) -> Vector2:
	@warning_ignore("integer_division")
	return Vector2(
		MARGIN_SIZE + (MARGIN_SIZE + SLOT_SIZE) * (index % SLOT_COLUMNS),
		MARGIN_SIZE + (MARGIN_SIZE + SLOT_SIZE) * (index / SLOT_COLUMNS),
	)

func _build_slots() -> void:
	slots_node.get_children().all(func(x): x.queue_free())
	slots.clear()
	for i in SLOT_COUNT:
		var s: Slot = Slot.get_new(i)
		s.position = _get_slot_position(i)
		Loggie.info(i, s.position)
		slots.append(s)
		slots_node.add_child(s)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_build_slots()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

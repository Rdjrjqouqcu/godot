extends Node2D

@onready var slots: Node2D = %slots



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for r in range(Globals.ROWS):
		for c in range(Globals.COLS):
			slots.add_child(Slot.instantiate(Vector2i(c, r)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

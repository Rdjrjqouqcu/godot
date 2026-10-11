@tool
extends GridContainer

@export var grid: GridContainer
@export var first_day: Container
@export var label_path: String = "Label"

@export_tool_button("number") var numbering = _do_numbers

func _do_numbers() -> void:
	if grid == null or first_day == null or label_path.is_empty():
		return
	var current_idx = 0
	for c in grid.get_children():
		if c == first_day:
			current_idx = 1
		if current_idx != 0:
			(c.get_node(label_path) as Label).text = "%02d" % current_idx
			current_idx += 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

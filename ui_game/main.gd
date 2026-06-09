extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for worker in %workers.get_children():
		worker.change_selected.connect(_change_selected)


func _change_selected(origin: Node):
	for worker in %workers.get_children():
		worker.is_selected = worker == origin

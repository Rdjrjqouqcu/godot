extends Node2D

@onready var field: HFlowContainer = %field
const PLOT = preload("res://scene/plot.tscn")

var selected: int = -1

func set_buttons_unselected() -> void:
	pass

func set_selected(index: int) -> void:
	if self.selected == index:
		index = -1
	self.selected = index
	
	if self.selected == -1:
		set_buttons_unselected()
	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in field.get_children():
		#child.queue_free()
		pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

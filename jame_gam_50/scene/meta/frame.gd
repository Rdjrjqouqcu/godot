extends Node2D

@export var pos: Vector2i = Vector2i.ZERO

@onready var label: Label = $Label

func redraw(board: Dictionary[Vector2i, bool]):
	label.text = str("occ: ", board.get(pos))

extends Node2D
class_name PlayerBadge

@onready
var shapes: Array[Sprite2D] = [
	$triangle,
	$circle,
	$diamond,
]

func _ready() -> void:
	for shape in shapes:
		shape.visible = false

func _show_display(state: Vector2i) -> void:
	var shape = shapes[state[0]]
	var color = Constants.colors[state[1]]
	shape.visible = true
	shape.modulate = color

func set_first(p1: bool, p2: bool, p3: bool, p1s: Vector2i, p2s: Vector2i, p3s: Vector2i) -> void:
	if p1:
		self._show_display(p1s)
	elif p2:
		self._show_display(p2s)
	elif p3:
		self._show_display(p3s)

func set_second(p1: bool, p2: bool, p3: bool, _p1s: Vector2i, p2s: Vector2i, p3s: Vector2i) -> void:
	if p1 and p2:
		self._show_display(p2s)
	elif (p1 or p2) and p3:
		self._show_display(p3s)

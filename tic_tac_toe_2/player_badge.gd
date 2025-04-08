extends Node2D
class_name PlayerBadge

func get_shape(offset: int) -> Sprite2D:
	return get_node(Constants.shape_names[offset])

func _ready() -> void:
	for shape in get_children():
		shape.visible = false

func _show_display(state: Vector2i) -> void:
	var shape = get_shape(state[0])
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

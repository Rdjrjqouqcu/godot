extends Node

const colors: Array[Color] = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1),
	Color(1, 1, 0),
	Color(1, 0, 1),
	Color(0, 1, 1),
]

const color_names: Array[String] = [
	"red",
	"green",
	"blue",
	"yellow",
	"magenta",
	"cyan",
]

const shape_names: Array[String] = [
	"triangle",
	"circle",
	"diamond",
	"hexagon",
	"star",
	"heart",
]

func _pass() -> void:
	pass

func _move_random(slots: Dictionary[Vector2i, Slot]) -> Vector2i:
	var available = []
	for s: Slot in slots.values():
		if s.is_playable():
			available.append(s.loc)
	if available.size() == 0:
		return Vector2i(0,0)
	return available[randi() % available.size()]

func _move_spiral(slots: Dictionary[Vector2i, Slot]) -> Vector2i:
	# https://stackoverflow.com/questions/398299/looping-in-a-spiral
	var x: int = 0
	var y: int = 0
	var dx: int = 0
	var dy: int = -1
	while slots.has(Vector2i(x, y)):
		var cur = Vector2i(x, y)
		if slots.get(cur).is_playable():
			return cur

		if x == y or (x < 0 and x == -y) or (x > 0 and x == 1 - y):
			var t = dx
			dx = -dy
			dy = t

		x = x + dx
		y = y + dy

	return Vector2i(0,0)

var npc_modes: Array[Callable] = [
	_pass,
	_move_random,
	_move_spiral,
]

const npc_mode_names: Array[String] = [
	"player",
	"random",
	"spiral",
]

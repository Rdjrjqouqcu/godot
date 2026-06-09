extends Node2D
class_name Slot

const size: Vector2i = Vector2i(25, 25)
const MAX_RADIUS: int = 25

var loc: Vector2i
var main: Main

var ore_red: int = 0
var ore_green: int = 0
var ore_blue: int = 0

var revealed: bool = false

var flag_red: int = 0
var flag_green: int = 0
var flag_blue: int = 0

func has_ore() -> bool:
	return ore_red != 0 or ore_green != 0 or ore_blue != 0
func is_revealed() -> bool:
	return revealed
func is_flagged() -> bool:
	return flag_red != 0 or flag_green != 0 or flag_blue != 0

func init_main(m: Main) -> void:
	main = m
	main.slot_cache.set(loc, self)

func add_ore(amt_red: int, amt_green: int, amt_blue: int) -> void:
	ore_red += amt_red
	ore_green += amt_green
	ore_blue += amt_blue

func reset() -> void:
	ore_red = 0
	ore_green = 0
	ore_blue = 0
	revealed = false
	flag_red = 0
	flag_green = 0
	flag_blue = 0
	$digit.visible = false
	$cover.visible = true

func _update_digit_color_flag() -> void:
	$digit.text = str(flag_red + flag_green + flag_blue) + "F"
	$digit.modulate = Color(
		1.0 if flag_red > 0 else 0.0,
		1.0 if flag_green > 0 else 0.0,
		1.0 if flag_blue > 0 else 0.0,
	)
	$digit.visible = is_flagged()

func _update_digit_color(red_count: int, green_count: int, blue_count: int, exposed: bool) -> void:
	$digit.text = str(red_count + green_count + blue_count) + ("X" if exposed else "")
	$digit.modulate = Color(
		1.0 if red_count > 0 else 0.0,
		1.0 if green_count > 0 else 0.0,
		1.0 if blue_count > 0 else 0.0,
	)
	$digit.visible = red_count + green_count + blue_count != 0
	$cover.visible = false

func reveal_digit() -> Array[Slot]:
	revealed = true
	if has_ore():
		main.handle_revealed_ore(ore_red, ore_green, ore_blue)
		_update_digit_color(ore_red, ore_green, ore_blue, true)
		for n: Slot in main.get_neighbor_slots(loc, 1):
			if not n.has_ore():
				n.reveal_area()
		return []
	var red_count = 0
	var green_count = 0
	var blue_count = 0
	var neighbors = main.get_neighbor_slots(loc, 1)
	for n: Slot in neighbors:
		if n.is_revealed():
			continue
		red_count += n.ore_red
		green_count += n.ore_green
		blue_count += n.ore_blue
	_update_digit_color(red_count, green_count, blue_count, false)
	if red_count + green_count + blue_count == 0:
		return neighbors
	return []

func reveal_area() -> void:
	var queue = reveal_digit()
	while not queue.is_empty():
		var s = queue.pop_back()
		if s.is_revealed() or s.is_flagged():
			continue
		var dist = max(abs(s.loc.x - loc.x), abs(s.loc.y - loc.y))
		if MAX_RADIUS <= dist:
			continue
		var n = s.reveal_digit()
		if dist < MAX_RADIUS:
			queue.append_array(n)

func flag_slot(r: int, g: int, b: int) -> void:
	if is_revealed():
		return
	flag_red = r if r != -1 else flag_red
	flag_green = g if g != -1 else flag_green
	flag_blue = b if b != -1 else flag_blue
	_update_digit_color_flag()

func _update_debug() -> void:
	$debug.text = str(
		ore_red, ore_green, ore_blue
	)

func _input_event(_view, event, _shape) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if is_flagged():
				if not main.is_flag_ready(flag_red, flag_green, flag_blue):
					return
			reveal_area()
			main.rclick(loc, self.position, true)
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			main.rclick(loc, self.position, self.is_revealed())
		#Loggie.info(loc, event)

func _ready() -> void:
	_update_debug()

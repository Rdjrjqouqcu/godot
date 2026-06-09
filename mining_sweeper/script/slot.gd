extends Node2D
class_name Slot

const size: Vector2i = Vector2i(25, 25)

var loc: Vector2i
var main: Main

var ore_red: int = 0
var ore_green: int = 0
var ore_blue: int = 0

var revealed: bool = false

var hint_value: int = 0
var hint_color: Color = Color(0,0,0,1)
var hint_is_flag: bool = false

#enum state {
	#EXPOSED, # has ore and is revealed
	#REVEALED, # does not have ore and is revealed
	#FLAGGED, # marked as flagged
	#HINTED, # marked as hinted
	#HIDDEN, # unrevealed and unhinted and unflagged
#}

func has_ore() -> bool:
	return ore_red != 0 or ore_green != 0 or ore_blue != 0
func is_revealed() -> bool:
	return revealed
func is_flagged() -> bool:
	return hint_value != 0 and hint_is_flag
func is_hinted() -> bool:
	return hint_value != 0 and not hint_is_flag
func is_hinted_or_flagged() -> bool:
	return hint_value != 0

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
	hint_value = 0
	hint_color = Color(0,0,0,1)
	hint_is_flag = false
	$digit.visible = false

func _update_digit_color_hint() -> void:
	$digit.text = str(hint_value) + ("F" if hint_is_flag else "H")
	$digit.modulate = hint_color
	$digit.visible = hint_value != 0

func _update_digit_color(red_count: int, green_count: int, blue_count: int, exposed: bool) -> void:
	$digit.text = str(red_count + green_count + blue_count) + ("X" if exposed else "")
	$digit.modulate = Color(
		1.0 if red_count > 0 else 0.0,
		1.0 if green_count > 0 else 0.0,
		1.0 if blue_count > 0 else 0.0,
	)
	$digit.visible = true

func reveal_digit() -> Array[Slot]:
	revealed = true
	if has_ore():
		main.handle_revealed_ore(ore_red, ore_green, ore_blue)
		_update_digit_color(ore_red, ore_green, ore_blue, true)
		return []
	var red_count = 0
	var green_count = 0
	var blue_count = 0
	var neighbors = main.get_neighbor_slots(loc, 1)
	for n: Slot in neighbors:
		red_count += n.ore_red
		green_count += n.ore_green
		blue_count += n.ore_blue
	_update_digit_color(red_count, green_count, blue_count, false)
	if red_count + green_count + blue_count == 0:
		return neighbors
	return []

func reveal_area() -> void:
	var max_radius = 15
	var queue = reveal_digit()
	while not queue.is_empty():
		var s = queue.pop_back()
		if s.is_revealed() or s.is_hinted_or_flagged():
			continue
		var dist = max(abs(s.loc.x - loc.x), abs(s.loc.y - loc.y))
		if max_radius <= dist:
			continue
		var n = s.reveal_digit()
		if dist < max_radius:
			queue.append_array(n)

func hint_slot(val: int, isFlag: bool, c:Color) -> void:
	if is_revealed():
		return
	hint_color = c
	hint_value = val
	hint_is_flag = isFlag
	_update_digit_color_hint()

func _update_debug() -> void:
	$debug.text = str(
		ore_red, ore_green, ore_blue
	)

func _input_event(_view, event, _shape) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			if not is_flagged():
				reveal_area()
				main.rclick(loc, self.position, true)
		elif event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			main.rclick(loc, self.position, self.is_revealed())
		#Loggie.info(loc, event)

func _ready() -> void:
	_update_debug()

func _process(_delta: float) -> void:
	pass

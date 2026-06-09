extends Node2D
class_name Slot

const size: Vector2i = Vector2i(25, 25)
const cascade_reveal: bool = true

var loc: Vector2i
var main: Main

var ore_red: int = 0
var ore_green: int = 0
var ore_blue: int = 0
var revealed: bool = false
func has_ore() -> bool:
	return ore_red != 0 or ore_green != 0 or ore_blue != 0

func init_main(m: Main) -> void:
	main = m
	main.slot_cache.set(loc, self)

func init_ore(amt_red: int, amt_green: int, amt_blue: int) -> void:
	ore_red = amt_red
	ore_green = amt_green
	ore_blue = amt_blue

func reset() -> void:
	ore_red = 0
	ore_green = 0
	ore_blue = 0
	revealed = false

func _update_digit_color(red_count: int, green_count: int, blue_count: int, primary: bool) -> void:
	$digit.text = str(red_count + green_count + blue_count)
	$digit.modulate = Color(
		1.0 if red_count > 0 else 0.0,
		1.0 if green_count > 0 else 0.0,
		1.0 if blue_count > 0 else 0.0,
		1.0 if primary else 0.5,
	)
	$digit.visible = true

func update_digit() -> Array[Slot]:
	if has_ore():
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
	if cascade_reveal:
		if red_count + green_count + blue_count == 0:
			return neighbors
	return []

func reveal() -> void:
	if revealed:
		return
	revealed = true
	update_digit()

func reveal_area() -> void:
	if not cascade_reveal:
		reveal()
		return
	revealed = true
	var max_radius = 15
	var queue = update_digit()
	while not queue.is_empty():
		var s = queue.pop_back()
		if s.revealed:
			continue
		var dist = max(abs(s.loc.x - loc.x), abs(s.loc.y - loc.y))
		if max_radius <= dist:
			continue
		s.revealed = true
		var n = s.update_digit()
		if dist < max_radius:
			queue.append_array(n)


func _update_debug() -> void:
	$debug.text = str(
		ore_red, ore_green, ore_blue
	)

func _input_event(_view, event, _shape) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			reveal_area()
		#Loggie.info(loc, event)


func _ready() -> void:
	_update_debug()


func _process(_delta: float) -> void:
	pass

extends Node2D
class_name Slot

const size: Vector2i = Vector2i(25, 25)
enum ORE_TYPE {
	NONE,
	IRON,
	COPPER,
}

var loc: Vector2i
var main: Main

var ore_amount: int = 0
var ore_type: ORE_TYPE = ORE_TYPE.NONE
var revealed: bool = false
func has_ore() -> bool:
	return ore_type != ORE_TYPE.NONE and ore_amount != 0

func init_main(m: Main) -> void:
	main = m
	main.slot_cache.set(loc, self)

func init_ore(amt: int, type: ORE_TYPE) -> void:
	ore_amount = amt
	ore_type = type

func reset() -> void:
	ore_amount = 0
	ore_type = ORE_TYPE.NONE
	revealed = false


func reveal() -> void:
	if revealed:
		return
	revealed = true
	if has_ore():
		Loggie.info("found", ore_amount, ore_type)
	else:
		var ore_count = {}
		for n in main.get_neighbor_slots(loc, 1):
			if n.has_ore():
				ore_count.set(n.ore_type, n.ore_amount + ore_count.get(n.ore_type, 0))
		Loggie.info(ore_count)

func _update_debug() -> void:
	$debug.text = str(
		ore_amount, ore_type
	)

func _input_event(_view, event, _shape) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			reveal()
		#Loggie.info(loc, event)


func _ready() -> void:
	_update_debug()


func _process(_delta: float) -> void:
	pass

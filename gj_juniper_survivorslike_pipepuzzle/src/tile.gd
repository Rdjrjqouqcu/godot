extends Node2D
class_name Tile

const CONNECTED_COLOR: Color = Color.YELLOW
const DISCONNECTED_COLOR: Color = Color.BEIGE
const size: Vector2i = Vector2i(32,32)

var loc: Vector2i

var connected_up: bool = false
var connected_right: bool = false
var connected_down: bool = false
var connected_left: bool = false

func get_connections() -> Array[bool]:
	return [connected_up, connected_right, connected_down, connected_left]

func _refresh_display_connections() -> void:
	$up.visible = connected_up
	$right.visible = connected_right
	$down.visible = connected_down
	$left.visible = connected_left
func update_connections(up: bool, right: bool, down: bool, left: bool) -> void:
	connected_up = up
	connected_right = right
	connected_down = down
	connected_left = left
	_refresh_display_connections()
func _randomize_direction() -> void:
	match randi_range(1, 6):
		1:
			match randi_range(1,4):
				1:
					connected_up = true
				2:
					connected_right = true
				3:
					connected_down = true
				4:
					connected_left = true
		2, 5:
			if randi() % 2 == 0:
				# straight
				if randi() % 2 == 0:
					connected_up = true
					connected_down = true
				else:
					connected_right = true
					connected_left = true
			else:
				# L
				if randi() % 2 == 0:
					connected_up = true
					if randi() % 2 == 0:
						connected_right = true
					else:
						connected_left = true
				else:
					connected_down = true
					if randi() % 2 == 0:
						connected_right = true
					else:
						connected_left = true
		3, 6:
			connected_up = true
			connected_right = true
			connected_down = true
			connected_left = true
			match randi_range(1,4):
				1:
					connected_up = false
				2:
					connected_right = false
				3:
					connected_down = false
				4:
					connected_left = false
		4:
			connected_up = true
			connected_right = true
			connected_down = true
			connected_left = true
	_refresh_display_connections()
func rotate_tile() -> void:
	var tmp = connected_left
	connected_left = connected_down
	connected_down = connected_right
	connected_right = connected_up
	connected_up = tmp
	_refresh_display_connections()

var is_powered: bool = false:
	set(val):
		is_powered = val
		if val:
			self.modulate = CONNECTED_COLOR
		else:
			self.modulate = DISCONNECTED_COLOR
	get:
		return is_powered
var power_depth: int = -1
func set_powered(p: bool, depth: int) -> bool:
	var skip_reprocessing = is_powered
	is_powered = p
	if power_depth < 0:
		power_depth = depth
	else:
		if depth < power_depth:
			skip_reprocessing = false
			power_depth = depth
	$Label.text = str(power_depth)
	$Label.self_modulate = Color.BLACK
	return skip_reprocessing



func _ready() -> void:
	_randomize_direction()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			rotate_tile()
			Level.instance.recalc_paths()

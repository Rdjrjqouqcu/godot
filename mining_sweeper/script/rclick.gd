extends Container

var menu: Node2D
var last_loc: Vector2i

const RED: int = 0
const GREEN: int = 1
const BLUE: int = 2
const COLOR_MAP: Array[Color] = [
	Color(1, 0, 0),
	Color(0, 1, 0),
	Color(0, 0, 1)
]

func _new_button(i: int, c: int) -> Button:
		var f = Button.new()
		f.text = "" + str(i + 1)
		f.modulate = COLOR_MAP[c]
		f.pressed.connect(_flag_click.bind(i + 1, c))
		return f

func _ready() -> void:
	var f = Button.new()
	f.text = "C"
	f.pressed.connect(_clear_click)
	%Flag.add_child(f)
	f = Button.new()
	f.text = "C"
	f.pressed.connect(_clear_click)
	%Flag.add_child(f)
	f = Button.new()
	f.text = "C"
	f.pressed.connect(_clear_click)
	%Flag.add_child(f)
	for i in range(9):
		%Flag.add_child(_new_button(i, RED))
		%Flag.add_child(_new_button(i, GREEN))
		%Flag.add_child(_new_button(i, BLUE))
	self.visible = false

func open_menu(m:Main, loc:Vector2i, pos: Vector2) -> void:
	var height = self.size.y + 3
	self.menu = m
	self.position = pos
	if self.position.y > get_viewport_rect().size.y - height:
		self.position.y = get_viewport_rect().size.y - height
	self.last_loc = loc
	self.visible = true

func _clear_click() -> void:
	self.visible = false
	menu.flag_slot(last_loc, 0, 0, 0)

func _flag_click(id: int, color: int) -> void:
	self.visible = false
	menu.flag_slot(
		last_loc,
		id if color == RED else 0,
		id if color == GREEN else 0,
		id if color == BLUE else 0,
	)

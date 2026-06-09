extends Container

const MENU_HEIGHT: int = 204

var menu: Node2D
var last_loc: Vector2i

func _ready() -> void:
	for i in range(9):
		var h = Button.new()
		h.text = "" + str(i + 1)
		h.pressed.connect(_hint_flag_click.bind(i + 1, false))
		%Hint.add_child(h)

		var f = Button.new()
		f.text = "" + str(i + 1)
		f.pressed.connect(_hint_flag_click.bind(i + 1, true))
		%Flag.add_child(f)

func open_menu(m:Main, loc:Vector2i, pos: Vector2) -> void:
	self.menu = m
	self.position = pos
	if self.position.y > get_viewport_rect().size.y - MENU_HEIGHT:
		self.position.y = get_viewport_rect().size.y - MENU_HEIGHT
	self.last_loc = loc
	self.visible = true

func _color_click(src: CheckBox) -> void:
	%red.set_pressed_no_signal(false)
	%green.set_pressed_no_signal(false)
	%blue.set_pressed_no_signal(false)
	src.set_pressed_no_signal(true)

func _clear_click() -> void:
	self.visible = false
	menu.interact_with_slot(
		last_loc,
		0 if %red.is_pressed() else -1,
		0 if %green.is_pressed() else -1,
		0 if %blue.is_pressed() else -1,
		false
	)

func _hint_flag_click(id: int, flag: bool) -> void:
	self.visible = false
	menu.interact_with_slot(
		last_loc,
		id if %red.is_pressed() else 0,
		id if %green.is_pressed() else 0,
		id if %blue.is_pressed() else 0,
		flag
	)

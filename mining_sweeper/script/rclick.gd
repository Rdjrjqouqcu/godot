extends Container

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
	self.last_loc = loc
	self.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _hint_flag_click(id: int, flag: bool) -> void:
	self.visible = false
	menu.set_node(last_loc, id, flag)

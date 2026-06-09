extends TextureRect

@export var x_pos = 0
@export var y_pos = 0
@export_enum("null", "x", "o") var state: String = "null"

@export var gs: Node = null
@export var sig: Signal

@onready var icon_x: Sprite2D = $icon_x
@onready var icon_o: Sprite2D = $icon_o

var x_color
var o_color

func set_colors(xc, oc):
	#Sprite2D
	x_color = xc
	o_color = oc

func set_pos(i, j):
	x_pos = i
	y_pos = j
	set_position(Vector2i(i * 128 - 64, j * 128 - 64))
	#print("added ", Vector2i(i, j), " at ", Vector2i(i * 128 - 64, j * 128 - 64))

# Called when the node enters the scene tree for the first time.
func _ready():
	icon_x.visible = false
	icon_o.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if gs == null or state != "null":
			return
		if gs.next_turn():
			state = "x"
			#icon_x.modulate = x_color
			icon_x.visible = true
			icon_o.visible = false
		else:
			state = "o"
			#icon_o.modulate = o_color
			icon_x.visible = false
			icon_o.visible = true
		sig.emit(x_pos, y_pos, state)
		print("set ", x_pos, " ", y_pos, " to ", state)







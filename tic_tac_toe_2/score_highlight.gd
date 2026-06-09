extends Node2D
class_name ScoreHighlight

var center: Vector2
var unit_length: int
var lines: Array[Node2D] = []
var slants: Array[Node2D] = []

const semicircle_tx = preload("res://Semicircle.png")
const square_tx = preload("res://Square.png")

func hide_all() -> void:
	for line in lines:
		line.set_visible(false)
	for slant in slants:
		slant.set_visible(false)

func display(left: Vector2i, right: Vector2i, new_color: Color) -> void:
	var new_loc = null
	hide_all()
	self.set_modulate(Color(new_color, 0.5))
	var min_x = min(left.x, right.x)
	var min_y = min(left.y, right.y)
	var len_x = max(left.x, right.x) - min_x + 1
	var len_y = max(left.y, right.y) - min_y + 1
	#print(left, " ", right)
	#print(Vector2(min_x, min_y)," ", Vector2(len_x, len_y))
	if len_x == 1 or len_y == 1:
		lines[max(len_x, len_y) - 1].set_visible(true)
		if len_y == 1:
			self.set_rotation_degrees(0)
		else:
			self.set_rotation_degrees(90)
			min_x += 1
		new_loc = Vector2(
			center.x + min_x * unit_length,
			center.y + min_y * unit_length
		)
	elif len_x == len_y:
		slants[len_x - 1].set_visible(true)
		var shift = 0
		if left.x == min_x:
			if left.y == min_y:
				self.set_rotation_degrees(0)
			else:
				self.set_rotation_degrees(-90)
				shift = 1
			new_loc = Vector2(
				center.x + min_x * unit_length,
				center.y + (left.y + shift) * unit_length
			)
		else:
			if right.y == min_y:
				self.set_rotation_degrees(0)
			else:
				self.set_rotation_degrees(-90)
				shift = 1
			new_loc = Vector2(
				center.x + min_x * unit_length,
				center.y + (right.y + shift) * unit_length
			)
	if new_loc != null:
		self.set_position(new_loc)

func init(c:Vector2, ul:int) -> void:
	center = c
	unit_length = ul
	hide_all()

func _make_line(length: int) -> Node2D:
	var node: Node2D = Node2D.new()
	
	var left: Sprite2D = Sprite2D.new()
	left.set_texture(semicircle_tx)
	left.set_centered(false)
	left.set_position(Vector2(0, 512))
	left.set_rotation_degrees(-90)
	node.add_child(left)
	
	var middle: Sprite2D = Sprite2D.new()
	middle.set_texture(square_tx)
	middle.set_centered(false)
	middle.set_position(Vector2(256, 0))
	middle.set_scale(Vector2(length - 1, 1))
	node.add_child(middle)
	
	var right: Sprite2D = Sprite2D.new()
	right.set_texture(semicircle_tx)
	right.set_centered(false)
	right.set_position(Vector2(512 * length, 0))
	right.set_rotation_degrees(90)
	node.add_child(right)
	
	node.set_visible(false)
	self.add_child(node)
	return node

func _make_slant(length: int) -> Node2D:
	var node: Node2D = Node2D.new()
	
	var left: Sprite2D = Sprite2D.new()
	left.set_texture(semicircle_tx)
	left.set_centered(false)
	left.set_position(Vector2(-106, 256))
	left.set_rotation_degrees(-45)
	node.add_child(left)
	
	var middle: Sprite2D = Sprite2D.new()
	middle.set_texture(square_tx)
	middle.set_centered(false)
	middle.set_position(Vector2(437, 75))
	middle.set_rotation_degrees(45)
	middle.set_scale(Vector2((length - 1) * sqrt(2), 1))
	node.add_child(middle)
	
	var right: Sprite2D = Sprite2D.new()
	right.set_texture(semicircle_tx)
	right.set_centered(false)
	right.set_position(Vector2(618 + (length - 1) * 512, 256 + (length - 1) * 512))
	right.set_rotation_degrees(135)
	node.add_child(right)
	
	node.set_visible(false)
	self.add_child(node)
	return node

func _ready() -> void:
	for i in range(1, 15 + 1):
		lines.append(_make_line(i))
	for i in range(1, 15 + 1):
		slants.append(_make_slant(i))

extends CharacterBody2D
class_name Player

static var instance: Player

var heads: Array[Head] = [
	preload("uid://dctt7b3wmewo"), # short
	preload("uid://3x55ec8clhid"), # medium
	preload("uid://bx8he5alws3r4"), # long
]
var bodies: Array[Body] = [
	preload("uid://bhn6uyw3tkyo5"), # red
	preload("uid://c3mjl3oep2k2g"), # green
	preload("uid://c7tb25h5324pj"), # blue
]
var legs: Array[Leg] = [
	preload("uid://bac25cftvfjan"), # slow
	preload("uid://gc3qb2ujgi8f"), # normal
	preload("uid://baqbqprrwi7gl"), # fast
]

var selected_head: Head
var selected_body: Body
var selected_leg: Leg

func select_set(h: Head, b: Body, l: Leg) -> void:
	selected_head = h
	selected_body = b
	selected_leg = l

	self.modulate = selected_body.color
	$attack_collision/circle.shape.radius = selected_head.attack_range

func _ready() -> void:
	Player.instance = self

func _physics_process(_delta: float) -> void:
	var direction = Input.get_vector("LEFT", "RIGHT", "UP", "DOWN").normalized()
	velocity = direction * selected_leg.move_speed
	move_and_slide()

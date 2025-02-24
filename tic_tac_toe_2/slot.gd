extends Node2D
class_name Slot

var loc: Vector2i
var clicked_callback: Callable

var enabled: bool = false
var played: bool = false

var p1: bool = false
var p2: bool = false
var p3: bool = false


@onready var label: Label = %Label
@onready var frame: TextureButton = $frame
@onready var badge: PlayerBadge = $badge
@onready var badge_1: PlayerBadge = $badge1
@onready var badge_2: PlayerBadge = $badge2
@onready var overload: Sprite2D = $overload


func init(location: Vector2i, clicked_cb: Callable, center:Vector2, unit_length:int) -> void:
	self.loc = location
	set_position(Vector2(loc.x * unit_length + center.x, loc.y * unit_length + center.y))
	self.clicked_callback = clicked_cb.bind(loc)
	if is_node_ready():
		frame.pressed.connect(clicked_callback)

func play(p1_here: bool, p2_here: bool, p3_here: bool, p1s: Vector2i, p2s: Vector2i, p3s: Vector2i) -> void:
	if self.played:
		return
	self.played = true
	self.p1 = p1_here
	self.p2 = p2_here
	self.p3 = p3_here
	if self.is_overloaded():
		overload.set_visible(true)
	elif player_count() == 2:
		badge_1.set_first(p1, p2, p3, p1s, p2s, p3s)
		badge_2.set_second(p1, p2, p3, p1s, p2s, p3s)
	else:
		badge.set_first(p1, p2, p3, p1s, p2s, p3s)
	_update_debug()
	
func player_count() -> int:
	return ((1 if p1 else 0) + (1 if p2 else 0) + (1 if p3 else 0))
	
func is_overloaded() -> bool:
	return player_count() >= 3

func is_playable() -> bool:
	return enabled and not played

func enable() -> void:
	enabled = true
	frame.modulate = Color(0.25, 0.25, 0.25)
	_update_debug()
	
func disable() -> void:
	enabled = false
	frame.modulate = Color(0.125, 0.125, 0.125)
	_update_debug()

func _update_debug() -> void:
	label.text = str(
		"pos: ", loc, "\n",
		"playable: ", is_playable(), "\n",
		"overloaded: ", is_overloaded(), "\n",
	)

func _ready() -> void:
	label.visible = false
	overload.set_visible(false)
	if clicked_callback != null:
		frame.pressed.connect(clicked_callback)
	disable()

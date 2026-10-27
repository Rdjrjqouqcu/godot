extends MarginContainer
class_name CardDragged

static var instance: CardDragged
static func inst() -> CardDragged: return instance

func _update_debug() -> void:
	$debug.text = "id=" + selected_id + " hid=" + hovering_id

func _ready() -> void:
	instance = self
	visible = false

func is_picked() -> bool:
	return visible

var hovering_id: String = ""
func hover(id: String) -> void:
	hovering_id = id
	_update_debug()

func unhover() -> void:
	hovering_id = ""
	_update_debug()
	

var selected_id: String = ""
func pick(id: String) -> void:
	visible = true
	selected_id = id
	_update_debug()

func drop() -> void:
	drop_cooldown = drop_cooldown_max
	visible = false

func can_pick() -> bool:
	return not drop_cooldown > 0

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if CardDragged.inst().is_picked():
			CardDragged.inst().drop()

@onready var offset = (
		$TextureRect.get_combined_maximum_size() + 
		Vector2(self.get_theme_constant("margin_left"), self.get_theme_constant("margin_top"))
	) / 2
const drop_cooldown_max = 0.1
var drop_cooldown = 0.0
func _process(delta: float) -> void:
	self.global_position = get_viewport().get_mouse_position() - offset
	if drop_cooldown > 0:
		drop_cooldown -= delta

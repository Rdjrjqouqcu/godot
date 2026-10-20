extends MarginContainer

@export var id: String = ""

func _ready() -> void:
	$debug.text = "id=" + id

const click_mode_distance = 10
const click_mode_timer_max = 0.5
var click_mode_timer: float = 0.0
func _process(delta: float) -> void:
	if click_mode_timer > 0:
		click_mode_timer -= delta
		if click_mode_timer <= 0:
			print("drag time")
			CardDragged.inst().pick(id)

func _on_gui_input(event: InputEvent) -> void:
	#print(event)
	if not CardDragged.inst().can_pick():
		return
	if event is InputEventMouseMotion:
		if click_mode_timer > 0:
			var dist = event.relative.length()
			click_mode_timer -= click_mode_timer_max * dist / click_mode_distance
			if click_mode_timer <= 0:
				print("drag dist")
				CardDragged.inst().pick(id)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.is_pressed():
				if CardDragged.inst().is_picked():
					CardDragged.inst().drop()
				else:
					click_mode_timer = click_mode_timer_max
			else:
				if click_mode_timer > 0:
					click_mode_timer = -1
					print("click")
					CardDragged.inst().pick(id)
				elif CardDragged.inst().is_picked():
					CardDragged.inst().drop()

extends Node2D
class_name Grave

@export var main: Main

var cow_captured: = false

func summon_start() -> void:
	$smoke.visible = true
func summon_done() -> void:
	$smoke.visible = false

func _hide_necromancer() -> void:
	$necromancer.visible = false
	$skeleton.set_necromancer_buff(false)
func show_necromancer() -> void:
	for g:Grave in get_tree().get_nodes_in_group("grave"):
		g._hide_necromancer()
	$necromancer.visible = true
	$skeleton.set_necromancer_buff(true)


func _ready() -> void:
	$skeleton.main = main
	$smoke.visible = false
	$necromancer.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func interact()-> void:
	self.show_necromancer()
	if not cow_captured:
		$skeleton.try_summon()

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			interact()


func _on_cow_entered(_area: Area2D) -> void:
	cow_captured = true
	$skeleton.done()
	main.check_win()

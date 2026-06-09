@tool
extends PanelContainer

@export var worker_name: String = "UNSET":
	set(new_name):
		worker_name = new_name
		$margin/flow/content/title.text = new_name

var active_job: Node = null:
	set(new_job):
		active_job = new_job
		if new_job == null:
			$margin/flow/content/job/remove.disabled = true
			$margin/flow/content/job/name.text = "Idle"
		else:
			$margin/flow/content/job/remove.disabled = false
			$margin/flow/content/job/name.text = "Active"
			# TODO notify job about change in worker

var is_selected: bool = false:
	set(select):
		if is_selected and is_selected == select:
			select = false
		is_selected = select
		$margin/flow/content/job/Label.visible = select

@export var durability_maximum: int = 100:
	set(new_maximum):
		durability_maximum = new_maximum
		_render_durability()

var durability_remaining: int = 100

func use_durability(amount: int) -> void:
	if durability_maximum == -1:
		return
	durability_remaining -= amount
	_render_durability()

func _render_durability():
	if durability_maximum == -1:
		$margin/flow/content/durability.text = "durability: infinite"
		return
	$margin/flow/content/durability.text = "durability: " + str(durability_remaining) + " / " + str(durability_maximum)

signal change_selected(me: Node)

func _clear_active_job() -> void:
	# TODO notify job about change in worker
	self.active_job = null

func select_worker(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		change_selected.emit(self)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$margin/flow/content/job/remove.disabled = true
	$margin/flow/content/job/name.text = "Idle"
	_render_durability()
	



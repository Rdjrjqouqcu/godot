extends Sprite2D

@onready var stick: Sprite2D = $stick

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$StickArea.visible = true
	$MouseArea.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


var total_dist: float = 0.0
const SMOKE_DIST = 250
func add_stirring(dist: float) -> void:
	@warning_ignore("integer_division")
	if floori(total_dist) / SMOKE_DIST != floori(total_dist + dist) / SMOKE_DIST:
		$"../Smoke".emit()
	total_dist += dist
	#print(total_dist)

var mouse_stick: bool = false
func _on_stick_area_mouse_entered() -> void: mouse_stick = true
func _on_stick_area_mouse_exited() -> void: mouse_stick = false
func _on_stick_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if mouse_stick:
		if event is InputEventMouseMotion:
			add_stirring((stick.global_position - event.global_position).length())
			stick.global_position = event.global_position


func _on_mouse_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			$"../Smoke".emit()

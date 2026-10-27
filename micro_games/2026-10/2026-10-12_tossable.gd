extends RigidBody3D

const TOSS_DIRECTION = Vector3(0.0, 1.0, -1.0)
const TOSS_STRENGTH = 0.05

var is_tossed: bool = false
var is_dragging: bool = false
var drag_start: Vector2

const RESET_TIME = 0.5
var _remaining_reset_time = RESET_TIME
func _process(delta: float) -> void:
	if _remaining_reset_time > 0:
		if linear_velocity.is_zero_approx() and angular_velocity.is_zero_approx():
			_remaining_reset_time -= delta
			if _remaining_reset_time <= 0:
				_do_reset_position(false)
		else:
			_remaining_reset_time = RESET_TIME

func _do_reset_position(reset_target: bool = true) -> void:
	if is_tossed:
		is_tossed = false
		$RespawnParticles.rotation = Vector3.UP
		$RespawnParticles.restart()
		self.linear_velocity = Vector3.ZERO
		self.angular_velocity = Vector3.ZERO
		self.set_deferred("global_position", %BoxSpawn.global_position)
		self.set_deferred("rotation", Vector3.ZERO)
		
	if reset_target:
		%Target.global_position = Vector3(
			randf_range(%TargetAA.global_position.x, %TargetBB.global_position.x),
			randf_range(%TargetAA.global_position.y, %TargetBB.global_position.y),
			randf_range(%TargetAA.global_position.z, %TargetBB.global_position.z)
		)
	
func _reset_position(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			_do_reset_position()

func _handle_release(event: InputEventMouseButton) -> void:
			is_dragging = false
			is_tossed = true
			_remaining_reset_time = RESET_TIME
			var drag_vector: Vector2 = event.global_position - drag_start
			%DragArrow.clear_arrow()
			var toss_vector = -TOSS_DIRECTION.rotated(Vector3(0.0, 1.0, 1.0).normalized(), -drag_vector.angle() + PI / 2.0) * drag_vector.length() * TOSS_STRENGTH
			self.apply_central_impulse(toss_vector)
			var forward_roll = randf_range(-1, 0)
			var pitch = clampf(rad_to_deg(drag_vector.angle() + PI / 2.0), -45, 45) / 45
			self.apply_torque_impulse(Vector3(forward_roll,pitch,0))
	

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and is_dragging:
		%DragArrow.update_arrow(drag_start, event.global_position)
	if event is InputEventMouseButton and is_dragging:
		if not event.pressed:
			_handle_release(event)


func _on_input_event(_camera: Node, event: InputEvent, _event_position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed and not is_dragging and not is_tossed:
			is_dragging = true
			drag_start = event.global_position
		elif is_dragging and not event.pressed:
			_handle_release(event)

var total_score: int = -1

func _on_target_entered(_body: Node3D) -> void:
	total_score += 1
	if total_score > 0:
		%TargetParticles.restart()
	%ScoreLabel.text = str(total_score)
	_do_reset_position()

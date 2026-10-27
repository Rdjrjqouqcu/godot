extends PanelContainer
class_name CountdownTimerPanel

@export var wait_time: float = 20.0
@export var auto_start: bool = false
@export var auto_restart: bool = false

@export_group("Warning Effects", "warning_effects_")
@export var warning_effects_enabled: bool = false
## will trigger at this second. for example, 5 will trigger at 5.00/4.99 but not 6.00/5.99
@export var warning_effects_seconds: int = 5
@export var warning_effects_trigger_on_zero: bool = false
## lead effect by attack time so the start of hold aligns with the second
@export var warning_effects_offset_by_attack_time: bool = true
@export var warning_effects_attack_time: float = 0.1
@export var warning_effects_hold_time: float = 0.2
@export var warning_effects_ease_time: float = 0.1
@export var warning_effects_scale: Vector2 = Vector2(1.25, 1.25)
@export var warning_effects_color: Color = Color.RED
var _warning_effects_tween: Tween

@onready var label: Label = $MarginContainer/Label

var _running = false
var _time_remaining: float = 0.0

signal timeout

func pause() -> void:
	_running = false

func resume() -> void:
	_running = true

func restart() -> void:
	_running = true
	_time_remaining = wait_time

func _ready() -> void:
	if auto_start:
		restart()

func _trigger_warning_effect() -> void:
	if _warning_effects_tween:
		_warning_effects_tween.kill()
	_warning_effects_tween = create_tween().set_parallel().set_trans(Tween.TRANS_CUBIC)
	_warning_effects_tween.set_ease(Tween.EASE_IN)
	_warning_effects_tween.tween_property(label, "offset_transform_scale", warning_effects_scale, warning_effects_attack_time)
	#_warning_effects_tween.tween_property(label, "offset_transform_rotation",deg_to_rad(randf_range(-15, 15)), warning_effects_attack_time)
	_warning_effects_tween.tween_property(label, "modulate", warning_effects_color, warning_effects_attack_time)
	_warning_effects_tween.chain()
	_warning_effects_tween.tween_interval(warning_effects_hold_time)
	_warning_effects_tween.chain()
	_warning_effects_tween.set_ease(Tween.EASE_OUT)
	_warning_effects_tween.tween_property(label, "offset_transform_scale", Vector2.ONE, warning_effects_ease_time)
	#_warning_effects_tween.tween_property(label, "offset_transform_rotation", 0.0, warning_effects_ease_time)
	_warning_effects_tween.tween_property(label, "modulate", Color.WHITE, warning_effects_ease_time)

func _handle_warning_effect(delta:float) -> void:
	if not warning_effects_enabled: return
	if not warning_effects_trigger_on_zero and _time_remaining <= 0: return
	var prev_time = _time_remaining + delta
	var cur_time = _time_remaining
	if warning_effects_offset_by_attack_time:
		prev_time -= warning_effects_attack_time
		cur_time -= warning_effects_attack_time
	if warning_effects_seconds <= cur_time: return
	var prev_remainder = prev_time - floorf(prev_time)
	var cur_remainder = cur_time - floorf(cur_time)
	if prev_remainder < cur_remainder:
		_trigger_warning_effect()

func _process(delta: float) -> void:
	if _running and _time_remaining >= 0.0:
		_time_remaining -= delta
		label.text = "%06.3f" % _time_remaining
		
		_handle_warning_effect(delta)
		
		if _time_remaining <= 0.0:
			label.text = "%06.3f" % 0.0
			timeout.emit()
			if auto_restart:
				_time_remaining += wait_time
			else:
				_running = false

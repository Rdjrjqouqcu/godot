extends Node2D
class_name Powerup

@export_enum("Speed", "Attack", "Duration") var buff_type: int

var main: Main

const TOAST_TIME = 1.0

func _ready() -> void:
	$effect.visible = false

var _cleanup_ready: bool = false
func _cleanup() -> void:
	# needs to be called twice
	if not _cleanup_ready:
		_cleanup_ready = true
		return
	self.queue_free()

func _on_area_2d_area_entered(_area: Area2D) -> void:
	Loggie.info("applied buff", buff_type)
	$audio.volume_linear = main.get_fx_volume_linear()
	$audio.play()
	match buff_type:
		0:
			main.add_speed_buff()
			$effect.text = "+speed"
			$effect.visible = true
		1:
			main.add_attack_buff()
			$effect.text = "+attack"
			$effect.visible = true
		2:
			main.add_durability_buff()
			$effect.text = "+durability"
			$effect.visible = true
	$area.queue_free()
	$sprite.visible = false
	var tween = create_tween()
	tween.set_parallel()
	var x = randf_range(-15, 15)
	var y = -50.0
	tween.tween_property($effect,"position:x", x, TOAST_TIME).as_relative()
	tween.tween_property($effect,"position:y", y, TOAST_TIME).as_relative()
	tween.chain().tween_callback(_cleanup)
	

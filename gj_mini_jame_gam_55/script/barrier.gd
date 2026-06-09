extends Node2D
class_name Barrier

@export var durability: float = 100.0
var main: Main

const hit_cooldown_max: float = 0.5
var hit_cooldown: float = 0

var is_broken: bool = false

func _break() -> void:
	is_broken = true
	$middle.visible = false
	$durability.visible = false
	$break.emitting = true
	$break_audio.volume_linear = main.get_fx_volume_linear()
	$break_audio.play()
	$area.queue_free()


func take_damage(val: float) -> bool:
	if is_broken:
		return true
	$durability.visible = true
	durability -= val
	$durability.value = durability
	if hit_cooldown <= 0:
		$hit.emitting = true
		$audio.volume_linear = main.get_fx_volume_linear()
		$audio.play()
		hit_cooldown = hit_cooldown_max
	if durability <= 0:
		_break()
		return true
	return false


func _ready() -> void:
	$durability.max_value = durability
	$durability.value = durability
	$durability.visible = false


func _process(delta: float) -> void:
	hit_cooldown = max(hit_cooldown - delta, 0)

extends Node2D
class_name Powerup

@export_enum("Speed", "Attack", "Duration") var buff_type: int

@export var main: Main




func _on_area_2d_area_entered(_area: Area2D) -> void:
	Loggie.info("applied buff", buff_type)
	match buff_type:
		0:
			main.add_speed_buff()
		1:
			main.add_attack_buff()
		2:
			main.add_durability_buff()
	self.queue_free()

extends Node

const _12_TOSS: PackedScene = preload("uid://dfscwhmgnf72r")


const map = {
	12: _12_TOSS,
}

func load_level(id: int) -> void:
	if id not in map.keys():
		return
	get_tree().change_scene_to_packed(_12_TOSS)


func _on_day_select(event: InputEvent, id: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			load_level(id)

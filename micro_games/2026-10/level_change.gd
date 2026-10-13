extends Node

const _12_TOSS: PackedScene = preload("uid://dfscwhmgnf72r")
const _15_WICKED_APOTHECARY: PackedScene = preload("uid://bu2beq2qnykme")


const map = {
	12: _12_TOSS,
	13: _15_WICKED_APOTHECARY,
	14: _15_WICKED_APOTHECARY,
	15: _15_WICKED_APOTHECARY,
}

func load_level(id: int) -> void:
	if id not in map.keys():
		return
	get_tree().change_scene_to_packed(map[id])


func _on_day_select(event: InputEvent, id: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			load_level(id)

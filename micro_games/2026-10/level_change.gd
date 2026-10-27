extends Node

const _12_TOSS: PackedScene = preload("uid://dfscwhmgnf72r")
const _15_WICKED_APOTHECARY: PackedScene = preload("uid://bu2beq2qnykme")
const _20_STICHED_TOGETHER: PackedScene = preload("uid://4yw3045us0oi")


const map = {
	12: _12_TOSS,
	13: _15_WICKED_APOTHECARY,
	14: _15_WICKED_APOTHECARY,
	15: _15_WICKED_APOTHECARY,
	16: _20_STICHED_TOGETHER,
	17: _20_STICHED_TOGETHER,
	18: _20_STICHED_TOGETHER,
	19: _20_STICHED_TOGETHER,
	20: _20_STICHED_TOGETHER,
	21: _20_STICHED_TOGETHER,
	22: _20_STICHED_TOGETHER,
	23: _20_STICHED_TOGETHER,
}

func load_level(id: int) -> void:
	if id not in map.keys():
		return
	get_tree().change_scene_to_packed(map[id])


func _on_day_select(event: InputEvent, id: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			load_level(id)

extends PanelContainer

const _2026_10_MENU: PackedScene = preload("uid://bqvprjfcllepx")



func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene_to_packed(_2026_10_MENU)

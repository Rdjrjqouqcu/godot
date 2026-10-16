extends PanelContainer

static var menu: PackedScene = null

func _ready() -> void:
	if menu == null:
		menu = load("res://2026-10/2026-10_menu.tscn")
	if OS.has_feature("2026-10-apothecary"):
		$"../Score".queue_free()
		self.queue_free()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			get_tree().change_scene_to_packed(menu)

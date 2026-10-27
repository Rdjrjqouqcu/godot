extends Control


const MAIN = preload("uid://udwpgvak4apd")
const LEVEL_1 = preload("uid://ivlbpcw1ftny")
const LEVEL_2 = preload("uid://b0gj2lpqg6dnp")


const scenes: Dictionary[int, PackedScene] = {
	1: LEVEL_1,
	2: LEVEL_2,
	3: MAIN,
	4: MAIN,
	5: MAIN,
	6: MAIN,
}


@onready var button_1: Button = $VBoxContainer/GridContainer/Button1
@onready var button_2: Button = $VBoxContainer/GridContainer/Button2
@onready var button_3: Button = $VBoxContainer/GridContainer/Button3
@onready var button_4: Button = $VBoxContainer/GridContainer/Button4
@onready var button_5: Button = $VBoxContainer/GridContainer/Button5
@onready var button_6: Button = $VBoxContainer/GridContainer/Button6


func _load_level(i: int) -> void:
	var _pass = i
	self.get_tree().change_scene_to_packed(scenes.get(i, null))


func _set_available(button: Button) -> void:
	button.disabled = false

func _set_unavailable(button: Button) -> void:
	button.disabled = true

func _set_completed(button: Button, done: bool) -> void:
	if done:
		button.modulate = Color.GREEN

func _ready() -> void:
	_update_buttons()

func _update_buttons() -> void:
	_set_available(button_1)
	(_set_available if Autoload.completed_1 else _set_unavailable).call(button_2)
	(_set_available if Autoload.completed_2 else _set_unavailable).call(button_3)
	(_set_available if Autoload.completed_3 else _set_unavailable).call(button_4)
	(_set_available if Autoload.completed_4 else _set_unavailable).call(button_5)
	var all_completed: bool = true
	for i in [[button_1, Autoload.completed_1], [button_2, Autoload.completed_2], [button_3, Autoload.completed_3],
			[button_4, Autoload.completed_4], [button_5, Autoload.completed_5]]:
		_set_completed.callv(i)
		all_completed = all_completed and i[1]
	button_6.visible = all_completed
	

func _process(_delta: float) -> void:
	pass


func _on_button_1_pressed() -> void: Autoload.completed_1 = true; _load_level(1)
func _on_button_2_pressed() -> void: Autoload.completed_2 = true; _load_level(2)
func _on_button_3_pressed() -> void: Autoload.completed_3 = true; _load_level(3)
func _on_button_4_pressed() -> void: Autoload.completed_4 = true; _load_level(4)
func _on_button_5_pressed() -> void: Autoload.completed_5 = true; _load_level(5)
func _on_button_6_pressed() -> void: _load_level(6)

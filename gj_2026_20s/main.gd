extends Control
class_name MainLevel

const is_importer_node := true

const LEVEL_SELECT = "uid://7oaovoj8fubd"

static var level_select: PackedScene = null


func _ready() -> void:
	if level_select == null:
		level_select = load(LEVEL_SELECT)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("close"):
		get_tree().change_scene_to_packed(level_select)

extends Node2D
class_name World

static var instance: World

const ENEMY = preload("uid://d1jp1o3xym1ap")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	World.instance = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			var e = ENEMY.instantiate()
			e.position = event.position
			add_child(e)

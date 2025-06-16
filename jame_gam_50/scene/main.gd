extends Node2D

const FRAME = preload("res://scene/frame.tscn")
@onready var frames: Node2D = $frames

func _init_frames() -> void:
	for i in range(16):
		for j in range(9):
			Loggie.info("adding frame", Vector2i(i,j))
			var frame = FRAME.instantiate()
			frame.global_position = Vector2i(i*120, j * 120)
			frames.add_child(frame)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_init_frames()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

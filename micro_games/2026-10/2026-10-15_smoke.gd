extends Node2D

const SMOKE_CLOUD = preload("uid://yq1k04xxnpji")
@onready var smoke_marker: Marker2D = $SmokeMarker


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func emit() -> void:
	var cloud: Node2D = SMOKE_CLOUD.instantiate()
	self.add_child(cloud)
	cloud.global_position = Vector2(
		randf_range(self.global_position.x, smoke_marker.global_position.x),
		randf_range(self.global_position.y, smoke_marker.global_position.y),
	)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

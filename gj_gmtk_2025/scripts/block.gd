extends StaticBody2D
class_name Block

func hit(height: int) -> bool:
	Loggie.info("block hit", height)
	return false

func _ready() -> void:
	add_to_group(Globals.GROUP_BLOCKS)

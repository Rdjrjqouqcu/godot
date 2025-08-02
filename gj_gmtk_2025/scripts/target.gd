extends Block
class_name Target

var break_finished: bool = false
func _break_finished() -> void:
	if not break_finished:
		break_finished = true
		return
	queue_free()

func _break() -> void:
	$white_fin.restart()
	$red_fin.restart()
	$CollisionShape2D.disabled = true
	$Sprite2D.visible = false

func hit(height: int) -> bool:
	Loggie.info("target hit", height)
	_break()
	return true


func _ready() -> void:
	add_to_group(Globals.GROUP_TARGETS)
	add_to_group(Globals.GROUP_BLOCKS)

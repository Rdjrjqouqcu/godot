extends TextureRect

const TIME_PER_FRAME: float = 0.05
const MAXIMUM_FRAME: int = 10

var current_frame: int = MAXIMUM_FRAME
var anim_cooldown: float = 0
func _process(delta: float) -> void:
	if anim_cooldown > 0:
		anim_cooldown -= delta
		if not anim_cooldown > 0:
			current_frame = min(current_frame + 1, MAXIMUM_FRAME)
			if current_frame != MAXIMUM_FRAME:
				anim_cooldown = TIME_PER_FRAME
			_update_frame()

func _update_frame() -> void:
	(texture as AtlasTexture).region = Rect2(current_frame * 32, 0, 32, 32)


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			if current_frame == MAXIMUM_FRAME:
				current_frame = 0
				anim_cooldown = TIME_PER_FRAME
				_update_frame()

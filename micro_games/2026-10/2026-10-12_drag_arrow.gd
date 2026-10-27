extends Control

const TINE_ANGLE_DEG = 15
const TINE_LEN_RATIO = 0.2

const ARROW_COLOR = Color.ORANGE_RED
const LINE_WIDTH = 4.0

var start: Vector2
var end: Vector2

func clear_arrow() -> void:
	start = Vector2.ZERO
	end = Vector2.ZERO
	queue_redraw()

func update_arrow(s: Vector2, e: Vector2) -> void:
	start = s
	end = e
	queue_redraw()

func _draw():
	if start.is_zero_approx() and end.is_zero_approx():
		return
	draw_line(start, end, ARROW_COLOR, LINE_WIDTH)
	var rev = end - start
	rev = rev.normalized() * TINE_LEN_RATIO * rev.length()
	draw_line(end, end - rev.rotated(deg_to_rad(TINE_ANGLE_DEG)), ARROW_COLOR, LINE_WIDTH)
	draw_line(end, end - rev.rotated(deg_to_rad(-TINE_ANGLE_DEG)), ARROW_COLOR, LINE_WIDTH)

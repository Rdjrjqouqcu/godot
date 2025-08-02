extends AnimatableBody2D

const ANIMATION_LEFT: String = "move_left"
const ANIMATION_RIGHT: String = "move_right"
const ANIMATION_DOWN: String = "move_down"

@export var level: Level
var queue_left: bool = false
var queue_right: bool = false
var wait_for_fall: bool = false
var fall_distance: int = 0

func _is_falling() -> bool:
	return $down.is_playing()

func _is_moving_horizontally() -> bool:
	return $left.is_playing() or $right.is_playing()

func _coord() -> Vector2i:
	return Globals.map_pos_to_coord(position)

func _has_neighbor_block(offset: Vector2i) -> bool:
	return level.cell_contains_block(_coord() + offset)

func _move_left() -> void:
	position = Globals.wrap_pos(position + (Vector2.LEFT * Globals.TILE_SIZE))
	$left.play(ANIMATION_LEFT)
	Loggie.info("move left", Globals.map_pos_to_coord(position))

func _move_right() -> void:
	position = Globals.wrap_pos(position + (Vector2.RIGHT * Globals.TILE_SIZE))
	$right.play(ANIMATION_RIGHT)
	Loggie.info("move right", Globals.map_pos_to_coord(position))

func _move_down() -> void:
	fall_distance += 1
	position = Globals.wrap_pos(position + (Vector2.DOWN * Globals.TILE_SIZE))
	$down.play(ANIMATION_DOWN)
	Loggie.info("move down", Globals.map_pos_to_coord(position))

func _move_down_left() -> void:
	fall_distance += 1
	position = Globals.wrap_pos(position + ((Vector2.DOWN + Vector2.LEFT) * Globals.TILE_SIZE))
	$down.play(ANIMATION_DOWN)
	$left.play(ANIMATION_LEFT)
	Loggie.info("move down left", Globals.map_pos_to_coord(position))

func _move_down_right() -> void:
	fall_distance += 1
	position = Globals.wrap_pos(position + ((Vector2.DOWN + Vector2.RIGHT) * Globals.TILE_SIZE))
	$down.play(ANIMATION_DOWN)
	$right.play(ANIMATION_RIGHT)
	Loggie.info("move down right", Globals.map_pos_to_coord(position))

func _try_move_left() -> void:
	if _is_falling():
		queue_left = true
		queue_right = false
		Loggie.info("QLa")
		return
	if _is_moving_horizontally():
		return
	if _has_neighbor_block(Vector2i.LEFT):
		return
	_move_left()

func _try_move_right() -> void:
	if _is_falling():
		queue_left = false
		queue_right = true
		Loggie.info("QRa")
		return
	if _is_moving_horizontally():
		return
	if _has_neighbor_block(Vector2i.RIGHT):
		return
	_move_right()

func _try_move_down() -> void:
	if _is_falling():
		return
	var left = queue_left
	var right = queue_right
	queue_left = false
	queue_right = false
	if _has_neighbor_block(Vector2i.DOWN):
		if left:
			_move_left()
		elif right:
			_move_right()
		return
	if left:
		_move_down_left()
	elif right:
		_move_down_right()
	else:
		_move_down()

func _try_move_up() -> void:
	position = Globals.wrap_pos(position + (Vector2.UP * Globals.TILE_SIZE))


func _process(_delta: float) -> void:
	if level.is_debug_enabled():
		if Input.is_action_just_pressed("ui_up"):
			_try_move_up()
		if Input.is_action_just_pressed("ui_down"):
			_try_move_down()
		if Input.is_action_just_pressed("ui_left"):
			_try_move_left()
		if Input.is_action_just_pressed("ui_right"):
			_try_move_right()
		return

	if Input.is_action_just_pressed("ui_left"):
		_try_move_left()
	if Input.is_action_just_pressed("ui_right"):
		_try_move_right()

	if _has_neighbor_block(Vector2i.DOWN):
		wait_for_fall = true
		fall_distance = 0
	else:
		if wait_for_fall:
			if not _is_moving_horizontally():
				_try_move_down()
		else:
			_try_move_down()



func _ready() -> void:
	wait_for_fall = _has_neighbor_block(Vector2i.DOWN)
	Loggie.info("anvil ready", wait_for_fall)

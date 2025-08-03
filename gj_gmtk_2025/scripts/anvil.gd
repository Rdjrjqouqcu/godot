extends Node2D

const PARTICLE_LIFETIMES: Array[float] = [0.25, 0.375, 0.5, 0.625]
const PARTICLE_COUNTS: Array[int] = [2,3,4,5]

const ANIMATION_LEFT: String = "move_left"
const ANIMATION_RIGHT: String = "move_right"
const ANIMATION_DOWN: String = "move_down"

var level: Level
var queue_left: bool = false
var queue_right: bool = false
var wait_for_fall: bool = false
var block_already_hit: bool = false
var fall_distance: int = 0

func _is_falling() -> bool:
	return %down.is_playing()
func _is_moving_horizontally() -> bool:
	return %left.is_playing() or %right.is_playing()
func _coord() -> Vector2i:
	return Globals.map_pos_to_coord(position)
func _get_neighbor_block(off: Vector2i) -> Block:
	return level.cell_get_block(Globals.wrap_coord(_coord() + off))
func _has_neighbor_block(off: Vector2i) -> bool:
	return _get_neighbor_block(off) != null

func _land() -> void:
	#Loggie.info("land", Globals.map_pos_to_coord(position))
	if fall_distance != 0:
		%land_audio.volume_linear = level.get_volume()
		%land_audio.play()
	block_already_hit = true
	wait_for_fall = true
	fall_distance = 0
	_change_speed()
func _move_left() -> void:
	block_already_hit = false
	wait_for_fall = true
	position = Globals.wrap_pos(position + (Vector2.LEFT * Globals.TILE_SIZE))
	%left.play(ANIMATION_LEFT)
	#Loggie.info("move left", Globals.map_pos_to_coord(position))
func _move_right() -> void:
	block_already_hit = false
	wait_for_fall = true
	position = Globals.wrap_pos(position + (Vector2.RIGHT * Globals.TILE_SIZE))
	%right.play(ANIMATION_RIGHT)
	#Loggie.info("move right", Globals.map_pos_to_coord(position))
func _move_down() -> void:
	fall_distance += 1
	block_already_hit = false
	wait_for_fall = false
	position = Globals.wrap_pos(position + (Vector2.DOWN * Globals.TILE_SIZE))
	_change_speed()
	%down.play(ANIMATION_DOWN)
	#Loggie.info("move down", Globals.map_pos_to_coord(position))
func _move_down_left() -> void:
	fall_distance += 1
	block_already_hit = false
	wait_for_fall = false
	position = Globals.wrap_pos(position + ((Vector2.DOWN + Vector2.LEFT) * Globals.TILE_SIZE))
	_change_speed()
	%down.play(ANIMATION_DOWN)
	%left.play(ANIMATION_LEFT)
	#Loggie.info("move down left", Globals.map_pos_to_coord(position))
func _move_down_right() -> void:
	fall_distance += 1
	block_already_hit = false
	wait_for_fall = false
	position = Globals.wrap_pos(position + ((Vector2.DOWN + Vector2.RIGHT) * Globals.TILE_SIZE))
	_change_speed()
	%down.play(ANIMATION_DOWN)
	%right.play(ANIMATION_RIGHT)
	#Loggie.info("move down right", Globals.map_pos_to_coord(position))

func _try_move_left() -> void:
	if _is_falling():
		queue_left = true
		queue_right = false
		return
	if _is_moving_horizontally():
		queue_left = true
		queue_right = false
		return
	if _has_neighbor_block(Vector2i.LEFT):
		return
	_move_left()
func _try_move_right() -> void:
	if _is_falling():
		queue_left = false
		queue_right = true
		return
	if _is_moving_horizontally():
		queue_left = false
		queue_right = true
		return
	if _has_neighbor_block(Vector2i.RIGHT):
		return
	_move_right()
func _try_move_down() -> void:
	if _is_falling():
		return
	if block_already_hit:
		return
	if wait_for_fall:
		if _is_moving_horizontally():
			return
	var left = queue_left
	var right = queue_right
	queue_left = false
	queue_right = false
	var down = _get_neighbor_block(Vector2i.DOWN)
	if down != null:
		# handle landing
		var broken = down.hit(fall_distance)
		if not broken:
			_land()
			if left and not _has_neighbor_block(Vector2i.LEFT):
				_move_left()
			elif right and not _has_neighbor_block(Vector2i.RIGHT):
				_move_right()
			return
	if (left
			and not _has_neighbor_block(Vector2i.LEFT + Vector2i.DOWN)
			and not _has_neighbor_block(Vector2i.LEFT) ):
		_move_down_left()
	elif (right
			and not _has_neighbor_block(Vector2i.RIGHT + Vector2i.DOWN)
			and not _has_neighbor_block(Vector2i.RIGHT) ):
		_move_down_right()
	else:
		_move_down()
func _try_move_up() -> void:
	position = Globals.wrap_pos(position + (Vector2.UP * Globals.TILE_SIZE))

func _change_speed() -> void:
	var speed = Globals.HEIGHT_LEVELS.bsearch(fall_distance) - 1
	#Loggie.info("speed", speed, fall_distance)
	%down.speed_scale = 1 + speed * 0.5
	%left.speed_scale = 1 + speed * 0.5
	%right.speed_scale = 1 + speed * 0.5
	var part_lifetime = PARTICLE_LIFETIMES[speed - 1]
	%speed1.lifetime = part_lifetime
	%speed2.lifetime = part_lifetime
	%speed3.lifetime = part_lifetime
	%speed4.lifetime = part_lifetime
	var part_amount = PARTICLE_COUNTS[speed - 1]
	%speed1.amount = part_amount * 12
	%speed2.amount = part_amount * 8
	%speed3.amount = part_amount * 4
	%speed4.amount = part_amount * 2
	if speed > 0:
		%speed1.emitting = true
	else:
		%speed1.emitting = false
	if speed > 1:
		%speed2.emitting = true
	else:
		%speed2.emitting = false
	if speed > 2:
		%speed3.emitting = true
	else:
		%speed3.emitting = false
	if speed > 3:
		%speed4.emitting = true
	else:
		%speed4.emitting = false

func _process(_delta: float) -> void:

	if level.is_debug_enabled():
		_land()
		if Input.is_action_just_pressed("up"):
			_try_move_up()
		if Input.is_action_just_pressed("down"):
			_try_move_down()
		if Input.is_action_just_pressed("left"):
			_try_move_left()
		if Input.is_action_just_pressed("right"):
			_try_move_right()
		return

	if Input.is_action_just_pressed("left"):
		_try_move_left()
	if Input.is_action_just_pressed("right"):
		_try_move_right()

	_try_move_down()

func _ready() -> void:
	var parent = get_parent()
	while not parent is Level:
		parent = parent.get_parent()
	level = parent as Level
	wait_for_fall = _has_neighbor_block(Vector2i.DOWN)
	_change_speed()

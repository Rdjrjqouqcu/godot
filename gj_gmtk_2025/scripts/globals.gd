extends Node
class_name Globals

const TILE_SIZE: int = 32

const BOARD_WIDTH: int = 20
const BOARD_HEIGHT: int = 16

const SCREEN_WIDTH: int = TILE_SIZE * BOARD_WIDTH # 640
const SCREEN_HEIGHT: int = TILE_SIZE * BOARD_HEIGHT # 512

const UI_HEIGHT: int = TILE_SIZE * 4 # 128

const GROUP_BLOCKS: String = "blocks"
const GROUP_TARGETS: String = "targets"

const HEIGHT_LEVELS: Array[int] = [0, 2, 4, 6, 8]

static func map_coord_to_pos(coord: Vector2i) -> Vector2:
	return Vector2(coord) * TILE_SIZE + Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)
static func map_pos_to_coord(pos: Vector2) -> Vector2i:
	return Vector2i((pos - Vector2(TILE_SIZE / 2.0, TILE_SIZE / 2.0)) / TILE_SIZE)

static func wrap_pos(pos: Vector2) -> Vector2:
	pos.x = wrap(pos.x, 0, SCREEN_WIDTH)
	pos.y = wrap(pos.y, 0, SCREEN_HEIGHT)
	return pos
static func wrap_coord(coord: Vector2i) -> Vector2i:
	coord.x = wrap(coord.x, 0, BOARD_WIDTH)
	coord.y = wrap(coord.y, 0, BOARD_HEIGHT)
	return coord

func _ready() -> void:
	get_window().size = Vector2i(SCREEN_WIDTH, SCREEN_HEIGHT + TILE_SIZE)
	ProjectSettings.set_setting("display/window/size/viewport_width", SCREEN_WIDTH)
	ProjectSettings.set_setting("display/window/size/viewport_height", SCREEN_HEIGHT + TILE_SIZE)

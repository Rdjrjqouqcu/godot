class_name Globals

const BOARD_WIDTH: int = 18
const BOARD_HEIGHT: int = 18

const TILE_SIZE: int = 64

# const VIEWPORT_SCALING = "display/window/stretch/scale" # 0.5
const VIEWPORT_WIDTH = BOARD_WIDTH * TILE_SIZE # 1152
const VIEWPORT_HEIGHT = BOARD_WIDTH * TILE_SIZE # 1152

static func map_position(pos: Vector2i) -> Vector2i:
	return pos * TILE_SIZE + Vector2i(TILE_SIZE / 2.0, TILE_SIZE / 2.0)

# palette: https://lospec.com/palette-list/burnt-retinas
const COLOR_BLACK: Color = Color("050112")
# 0f0c19 unused
# 15121d unused
# 1a1821 unused
# 212228 unused
const COLOR_GRAY: Color = Color("292d30")
const COLOR_LIGHT_GRAY: Color = Color("44484b")
const COLOR_DARK_PURPLE: Color = Color("290c52")
const COLOR_PURPLE: Color = Color("3c0e7d")
const COLOR_LIGHT_PURPLE: Color = Color("4d2ca0")
const COLOR_BLUE: Color = Color("3e66aa")
const COLOR_GREEN: Color = Color("29b25c")
const COLOR_LIME: Color = Color("b4d525")
const COLOR_ORANGE: Color = Color("c14119")
const COLOR_WHITE: Color = Color("fffff8")

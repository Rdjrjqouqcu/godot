extends Node

const TILE_SIZE: int = 32

const BOARD_WIDTH: int = 20
const BOARD_HEIGHT: int = 30

const SCREEN_WIDTH: int = TILE_SIZE * BOARD_WIDTH # 640
const SCREEN_HEIGHT: int = TILE_SIZE * BOARD_HEIGHT # 960


func _ready() -> void:
	get_window().size = Vector2i(SCREEN_WIDTH, SCREEN_HEIGHT)
	ProjectSettings.set_setting("display/window/size/viewport_width", SCREEN_WIDTH)
	ProjectSettings.set_setting("display/window/size/viewport_height", SCREEN_HEIGHT)

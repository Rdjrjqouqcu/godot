class_name SavedData
extends Resource

@export var version_index: int = SAVE_VERSION

@export var count_fly: int
@export var count_spider: int
@export var count_bird: int
@export var count_cat: int
@export var count_dog: int
@export var count_cow: int
@export var count_horse: int

const SAVE_VERSION: int = 0
const SAVE_PATH: String = "user://savegame.tres"

func do_save():
	ResourceSaver.save(self, SAVE_PATH)

static func do_load() -> SavedData:
	var data: SavedData = SafeResourceLoader.load(SAVE_PATH)
	if data == null:
		Loggie.error("Save data rejected")
		return null
	if SAVE_VERSION != data.version_index:
		Loggie.error("Save version rejected")
		return null
	return data

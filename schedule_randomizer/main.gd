extends MarginContainer

@onready var date_entry: TextEdit = %dateEntry
@onready var container: GridContainer = %container
@onready var err: Label = %err


const format: String = "%Y-%m-%d"

const CANCEL = preload("res://gameicons/cancel.png")
const CHECK_MARK = preload("res://gameicons/check-mark.png")
const STOPWATCH = preload("res://gameicons/stopwatch.png")


class LineEntry:
	var line: String
	var icon: Resource
	var color: Color
	func _init(l: String, i: Resource, c: Color):
		line = l
		icon = i
		color = c
var result_error: LineEntry = LineEntry.new("Error", STOPWATCH, Color.PURPLE)
var results: Dictionary[int, LineEntry] = {
	0: LineEntry.new("Not Today", CANCEL, Color.RED),
	1: LineEntry.new("After Dinner (7pm)", STOPWATCH, Color.ORANGE),
	2: LineEntry.new("After Lunch (2pm)", STOPWATCH, Color.YELLOW),
	3: LineEntry.new("After Lunch (2pm)", STOPWATCH, Color.YELLOW),
	4: LineEntry.new("Anytime", CHECK_MARK, Color.GREEN),
	5: LineEntry.new("Anytime", CHECK_MARK, Color.GREEN),
}

func _get_seed(dt: DateTime) -> int:
	return dt.year * 10000 + dt.month * 100 + dt.day

func _add_row(dt: DateTime) -> void:
	var date = Label.new()
	var roll = Label.new()
	var icon = TextureRect.new()
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.custom_minimum_size = Vector2(20, 20)
	icon.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	icon.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	var info = Label.new()
	var val = rand_from_seed(_get_seed(dt))[0] % 6
	var res: LineEntry = results.get(val, result_error)

	date.text = dt.strftime(format + " %a")
	roll.text = str("  ", val + 1, "  ")
	info.text = res.line
	icon.texture = res.icon
	icon.modulate = res.color

	container.add_child(date)
	container.add_child(roll)
	container.add_child(icon)
	container.add_child(info)

func _display_error(txt: String) -> void:
	err.text = txt
	err.visible = true
	print("err: ", txt)

func _update() -> void:
	var split = date_entry.text.split("-")
	if len(split) != 3 or !split[0].is_valid_int() or !split[1].is_valid_int() or !split[2].is_valid_int():
		_display_error("format error, use YYYY-MM-DD")
		return

	var dt = DateTime.datetime({"year": int(split[0]), "month": int(split[1]), "day": int(split[2])})
	if dt == null:
		_display_error("parse error, invalid date")
		return

	err.visible = false

	print("parsed date: ", dt)

	for child in container.get_children():
		child.queue_free()

	for i in range(0, 15):
		_add_row(dt.add_days(i))


const secondsPerDay = 24 * 60 * 60
func _ready() -> void:
	var dt = DateTime.from_timestamp(
		Time.get_unix_time_from_system() - secondsPerDay,
		Time.get_datetime_dict_from_system()["dst"])
	date_entry.text = dt.strftime(format)
	_update()

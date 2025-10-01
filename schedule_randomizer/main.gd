extends MarginContainer

@onready var date_entry: TextEdit = %dateEntry
@onready var container: GridContainer = %container
@onready var err: Label = %err
@onready var show_roll: CheckButton = %show

const format: String = "%Y-%m-%d"

const CANCEL = preload("res://gameicons/cancel.png")
const CHECK_MARK = preload("res://gameicons/check-mark.png")
const STOPWATCH = preload("res://gameicons/stopwatch.png")

enum LineEntryMode {
	ICON,
	COUNT,
	TEXT,
}
class LineEntry:
	var mode: LineEntryMode
	var line: String
	var icon: Resource
	var count: int
	var color: Color
	var lset: LabelSettings
	func add_row(roll: int, container: GridContainer, show_roll: bool) -> void:
		if show_roll:
			var r = Label.new()
			r.text = str("r=", roll, "")
			r.modulate = Color.GRAY
			container.add_child(r)
		match mode:
			LineEntryMode.ICON:
				add_row_icon(container)
			LineEntryMode.COUNT:
				add_row_count(container)
			LineEntryMode.TEXT:
				add_row_text(container)

	static func new_icon(l: String, i: Resource, c: Color) -> LineEntry:
		var n = LineEntry.new()
		n.mode = LineEntryMode.ICON
		n.line = l
		n.icon = i
		n.color = c
		return n
	func add_row_icon(container: GridContainer) -> void:
		var icn = TextureRect.new()
		icn.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icn.custom_minimum_size = Vector2(20, 20)
		icn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		icn.texture = self.icon
		icn.modulate = self.color
		container.add_child(icn)

		var info = Label.new()
		info.text = self.line
		container.add_child(info)

	static func new_count(i: int, l: String) -> LineEntry:
		var n = LineEntry.new()
		n.mode = LineEntryMode.COUNT
		n.line = l
		n.count = i
		return n
	func add_row_count(container: GridContainer) -> void:
		var cnt = Label.new()
		cnt.text = str(self.count)
		container.add_child(cnt)

		var info = Label.new()
		info.text = self.line
		container.add_child(info)

	static func new_text(l: String, c: Color = Color.WHITE) -> LineEntry:
		var n = LineEntry.new()
		n.mode = LineEntryMode.TEXT
		n.line = l
		n.color = c
		return n
	func add_row_text(container: GridContainer) -> void:
		var padding = Label.new()
		padding.text = ""
		container.add_child(padding)
		var info = Label.new()
		info.text = self.line
		info.modulate = color
		container.add_child(info)

# WIP
#class DataSource:
	#var random: Callable
	#func get_count() -> int:
		#return 0

var result_error: LineEntry = LineEntry.new_icon("Error", STOPWATCH, Color.PURPLE)
var results_time: Array[LineEntry] = [
	LineEntry.new_icon("Not Today", CANCEL, Color.RED),
	LineEntry.new_icon("After Dinner (7pm)", STOPWATCH, Color.ORANGE),
	LineEntry.new_icon("After Lunch (2pm)", STOPWATCH, Color.YELLOW),
	LineEntry.new_icon("After Lunch (2pm)", STOPWATCH, Color.YELLOW),
	LineEntry.new_icon("Anytime", CHECK_MARK, Color.GREEN),
	LineEntry.new_icon("Anytime", CHECK_MARK, Color.GREEN),
]
var results_tasks: Array[LineEntry] = [
	LineEntry.new_text("4 tasks", Color.RED),
	LineEntry.new_text("3 tasks", Color.ORANGE),
	LineEntry.new_text("3 tasks", Color.ORANGE),
	LineEntry.new_text("2 task", Color.YELLOW),
	LineEntry.new_text("2 task", Color.YELLOW),
	LineEntry.new_text("1 task", Color.GREEN_YELLOW),
	LineEntry.new_text("1 tasks", Color.GREEN_YELLOW),
	LineEntry.new_text("0 tasks", Color.GREEN),
	LineEntry.new_text("0 tasks", Color.GREEN),
]
var results_restriction: Array[LineEntry] = [
	LineEntry.new_text("Not Today", Color.RED),
	LineEntry.new_text("At Night", Color.YELLOW),
	LineEntry.new_text("At Night", Color.YELLOW),
	LineEntry.new_text("Anytime", Color.GREEN),
	LineEntry.new_text("Anytime", Color.GREEN),
	LineEntry.new_text("Anytime", Color.GREEN),
]
func random_raw(s: int, l: int) -> int:
	return rand_from_seed(s)[0] % l
func random_distributed(s: int, l: int) -> int:
	var r = s % l
	var s2 = s - r
	var offset = range(l)
	seed(s2)
	offset.shuffle()
	return offset[r]
var data_randoms: Array[Callable] = [
	random_distributed,
	random_distributed,
]
var data_sources: Array[Array] = [
	results_tasks,
	results_restriction,
]

func get_or_error(source: Array[LineEntry], index: int) -> LineEntry:
	if index < 0 or index >= source.size():
		return result_error
	return source[index]

func _get_seed(dt: DateTime, offset: int = 0) -> int:
	return offset * 100000000 + dt.year * 10000 + dt.month * 100 + dt.day

func _add_row(dt: DateTime) -> void:
	var date = Label.new()
	date.text = dt.strftime(format + " %a")
	container.add_child(date)

	for i in range(len(data_sources)):
		var source: Array[LineEntry] = data_sources[i]
		var l: int = source.size()
		var s: int = _get_seed(dt, i)
		var val: int = data_randoms[i].call(s, l)
		var res: LineEntry = get_or_error(source, val)
		res.add_row(val, container, show_roll.button_pressed)

func _display_error(txt: String) -> void:
	err.text = txt
	err.visible = true
	print("err: ", txt)

func _update() -> void:
	container.columns = 1 + (2 + (1 if show_roll.button_pressed else 0)) * len(data_sources)

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
		int(Time.get_unix_time_from_system() - secondsPerDay),
		Time.get_datetime_dict_from_system()["dst"])
	date_entry.text = dt.strftime(format)
	_update()

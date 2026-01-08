extends MarginContainer

const DATE_FORMAT: String = "%Y-%m-%d"
const SECONDS_PER_DAY: int = 24 * 60 * 60

const CANCEL: Resource = preload("res://gameicons/cancel.png")
const CHECK_MARK: Resource = preload("res://gameicons/check-mark.png")
const STOPWATCH: Resource = preload("res://gameicons/stopwatch.png")

class DataSourceUtil:
	static func _get_roll_node(roll: Variant) -> Node:
		var r = Label.new()
		r.text = str("r=", roll, "")
		r.modulate = Color.GRAY
		return r

	static func _get_seed_day_of_month(dt: DateTime, offset: int = 0) -> int:
		return offset * 1_0000_00_00 + dt.year * 1_00_00 + dt.month * 1_00 + dt.day
	static func _get_seed_day_of_year(dt: DateTime, offset: int = 0) -> int:
		return offset * 1_0000_000 + dt.year * 1_000 + dt._get_day_of_year()
	static func _get_seed_month_of_year(dt: DateTime, offset: int = 0) -> int:
		return offset * 1_0000_00 + dt.year * 1_00 + dt.month
	static func _get_seed_week_of_year(dt: DateTime, offset: int = 0) -> int:
		var wk = dt._get_week_of_year()
		# 13 + wk to prevent month_of_year collisions
		return offset * 1_0000_00 + dt.year * 1_00 + (13 + wk)

	static func _random_distributed(seed_used: int, entry_count: int) -> int:
		var seed_offset = seed_used % entry_count
		var seed_floored = seed_used - seed_offset
		var offsets = range(entry_count)
		seed(seed_floored)
		offsets.shuffle()
		return offsets[seed_offset]

@abstract class DataSource extends DataSourceUtil:
	@abstract func _get_data(dt: DateTime, row_offset: int) -> Array[Node]
	@abstract func get_column_count(show_roll: bool) -> int
	func add_row(container: GridContainer, dt: DateTime, row_offset: int, show_roll: bool) -> void:
		for n in _get_data(dt, row_offset).slice(0 if show_roll else 1):
			container.add_child(n)

class TimeDataSource extends DataSource:
	const entries_old = [
		["Not Today", CANCEL, Color.RED],
		["After Dinner (7pm)", STOPWATCH, Color.ORANGE],
		["After Lunch (2pm)", STOPWATCH, Color.YELLOW],
		["After Lunch (2pm)", STOPWATCH, Color.YELLOW],
		["Anytime", CHECK_MARK, Color.GREEN],
		["Anytime", CHECK_MARK, Color.GREEN],
	]
	const entries = [
		["Not Today", CANCEL, Color.RED],  # 4 tasks
		["Night(7pm)", STOPWATCH, Color.ORANGE], # 3 tasks
		["Night(7pm)", STOPWATCH, Color.ORANGE], # 3 tasks
		["Afternoon(3pm)", STOPWATCH, Color.YELLOW], # 2 tasks
		["Afternoon(3pm)", STOPWATCH, Color.YELLOW], # 2 tasks
		["Morning(11am)", STOPWATCH, Color.GREEN_YELLOW], # 1 task
		["Morning(11am)", STOPWATCH, Color.GREEN_YELLOW], # 1 task
		["Anytime", CHECK_MARK, Color.GREEN], # 0 tasks
		["Anytime", CHECK_MARK, Color.GREEN], # 0 tasks
	]

	func get_column_count(show_roll: bool) -> int:
		return 2 + (1 if show_roll else 0)

	func _get_data(dt: DateTime, row_offset: int) -> Array[Node]:
		var seed_used = _get_seed_day_of_month(dt, row_offset)
		var roll = _random_distributed(seed_used, entries.size())

		var line = entries[roll][0]
		var icon = entries[roll][1]
		var color = entries[roll][2]

		var icn = TextureRect.new()
		icn.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icn.custom_minimum_size = Vector2(20, 20)
		icn.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		icn.size_flags_vertical = Control.SIZE_SHRINK_CENTER
		icn.texture = icon
		icn.modulate = color

		var info = Label.new()
		info.text = line
		info.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
		info.modulate = color

		return [_get_roll_node(roll), info, icn, ]

class RestrictionDataSource extends DataSource:
	const entries = [
		["Not Today", Color.RED],
		["At Night", Color.YELLOW],
		["At Night", Color.YELLOW],
		["Anytime", Color.GREEN],
		["Anytime", Color.GREEN],
		["Anytime", Color.GREEN],
	]

	func get_column_count(show_roll: bool) -> int:
		return 1 + (1 if show_roll else 0)

	func _get_data(dt: DateTime, row_offset: int) -> Array[Node]:
		var hbox = HBoxContainer.new()

		var seed_monthly = _get_seed_month_of_year(dt, row_offset)
		seed(seed_monthly)
		var first_monthly = randi_range(1,14)
		var second_monthly = randi_range(15,28)
		if dt.day == first_monthly or dt.day == second_monthly:
			var binfo = Label.new()
			binfo.text = "BORED"
			binfo.modulate = Color.PURPLE
			hbox.add_child(binfo)

		var seed_used = _get_seed_week_of_year(dt, row_offset)
		var roll = _random_distributed(seed_used, entries.size())
		if dt.weekday_name == "monday":
			var info = Label.new()
			info.text = entries[roll][0]
			info.modulate = entries[roll][1]
			hbox.add_child(info)

		return [_get_roll_node([roll, first_monthly, second_monthly]), hbox]


var data_sources: Array[DataSource] = [
	TimeDataSource.new(),
	RestrictionDataSource.new(),
]


func _add_row(dt: DateTime) -> void:
	var date = Label.new()
	date.text = dt.strftime(DATE_FORMAT + " %a")
	%container.add_child(date)

	for i in range(len(data_sources)):
		data_sources[i].add_row(%container, dt, i, %show.button_pressed)

func _display_error(txt: String) -> void:
	%err.text = txt
	%err.visible = true
	print("err: ", txt)

func _update() -> void:
	var souce_cols = 0
	for source in data_sources:
		souce_cols += source.get_column_count(%show.button_pressed)
	%container.columns = 1 + souce_cols

	var split = %dateEntry.text.split("-")
	if len(split) != 3 or !split[0].is_valid_int() or !split[1].is_valid_int() or !split[2].is_valid_int():
		_display_error("format error, use YYYY-MM-DD")
		return

	var dt = DateTime.datetime({"year": int(split[0]), "month": int(split[1]), "day": int(split[2])})
	if dt == null:
		_display_error("parse error, invalid date")
		return

	%err.visible = false

	print("parsed date: ", dt)

	for child in %container.get_children():
		child.queue_free()

	for i in range(0, 15):
		_add_row(dt.add_days(i))

func _ready() -> void:
	var dt = DateTime.from_timestamp(
		int(Time.get_unix_time_from_system() - SECONDS_PER_DAY),
		Time.get_datetime_dict_from_system()["dst"])
	%dateEntry.text = dt.strftime(DATE_FORMAT)
	_update()

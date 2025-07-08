extends MarginContainer

@onready var date_entry: TextEdit = %dateEntry
@onready var container: GridContainer = %container
@onready var err: Label = %err


const format: String = "%Y-%m-%d"

const results: Dictionary[int,String] = {
	0: "❌ No Games",
	1: "🕖 After Dinner (7pm)",
	2: "🕑 After Lunch (2pm)",
	3: "🕑 After Lunch (2pm)",
	4: "✅ Anytime",
	5: "✅ Anytime",
}

func _get_seed(dt: DateTime) -> int:
	return dt.year * 10000 + dt.month * 100 + dt.day

func _add_row(dt: DateTime) -> void:
	var date = Label.new()
	var roll = Label.new()
	var info = Label.new()
	var val = rand_from_seed(_get_seed(dt))[0] % 6

	date.text = dt.strftime(format)
	roll.text = str("  ", val + 1, "  ")
	info.text = results.get(val, "error")

	container.add_child(date)
	container.add_child(roll)
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

	for i in range(0, 14):
		_add_row(dt.add_days(i))


func _ready() -> void:
	var dt = DateTime.now()
	date_entry.text = dt.strftime(format)
	_update()

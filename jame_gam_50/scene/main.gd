extends Node2D
class_name Main

enum Difficulty {
	EASY = 0,
	MEDIUM = 1,
	HARD = 2,
}

@onready var pop_display: RichTextLabel = %popDisplay
@onready var chip_display: RichTextLabel = %chipDisplay
@onready var time_display: RichTextLabel = %timeDisplay

const FRAME = preload("res://scene/meta/frame.tscn")
@onready var frames: Node2D = $frames

var collected_chips = 0
var total_chips = 10
var remaining_population = 1_000_000_000
var time_elapsed_ms = 0

func add_circuit() -> void:
	collected_chips += 1
	redraw_text()
	if collected_chips >= total_chips:
		Loggie.warn("WIN")
		# TODO handle WIN

func redraw_text() -> void:
	var text = ""
	var pop = remaining_population
	while pop >= 1000:
		text += ",%03d" % (pop % 1000)
		pop /= 1000
	pop_display.text = str(pop, text)
	chip_display.text = str(collected_chips, "/", total_chips)
	text = ""
	@warning_ignore("integer_division")
	var tmin:int = time_elapsed_ms / 60 / 100
	@warning_ignore("integer_division")
	var sec:int = floori(time_elapsed_ms / 100) % 60
	var ms:int = floori(time_elapsed_ms) % 100
	time_display.text = "%02d:%02d.%02d" % [tmin, sec, ms]

func _init_frames() -> void:
	for i in range(16):
		for j in range(9):
			var frame = FRAME.instantiate()
			frame.global_position = Vector2i(i*120, j * 120)
			frames.add_child(frame)

func _ready() -> void:
	seed(0)
	_init_frames()
	redraw_text()
	add_child(PuzzleCircuit2x1.create_circuit_2x1(Vector2i(2,2)))
	add_child(PuzzleShield1x1.create_shield_1x1(Vector2i(3,3)))
	add_child(PuzzleShield1x1.create_shield_1x1(Vector2i(3,4)))

func _process(delta: float) -> void:
	time_elapsed_ms += delta * 100
	redraw_text()

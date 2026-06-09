extends Node2D
class_name Main

var has_speed_buff: bool = false
var has_attack_buff: bool = false
var has_durability_buff: bool = false

func add_speed_buff() -> void:
	has_speed_buff = true
func add_attack_buff() -> void:
	has_attack_buff = true
func add_durability_buff() -> void:
	has_durability_buff = true

func check_win() -> void:
	# TODO win fx
	if $"Rows/1/Grave".cow_captured and $"Rows/2/Grave".cow_captured and $"Rows/3/Grave".cow_captured:
		Loggie.info("WIN")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"Rows/1/Grave".show_necromancer()
	
	# randomize buff position
	var buffs = [0, 1, 2]
	buffs.shuffle()
	$"Rows/1/powerup".buff_type = buffs[0]
	$"Rows/2/powerup".buff_type = buffs[1]
	$"Rows/3/powerup".buff_type = buffs[2]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		$"Rows/1/Grave".interact()
	if event.is_action_pressed("2"):
		$"Rows/2/Grave".interact()
	if event.is_action_pressed("3"):
		$"Rows/3/Grave".interact()

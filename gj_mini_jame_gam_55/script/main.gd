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

func get_fx_volume_linear() -> float:
	return $sound.get_fx_volume_linear()


const s1 = preload("uid://chpcmb2b5eb08")
const s2 = preload("uid://cuagfl1p1gt5i")
const s3 = preload("uid://cdvb40kkgom3r")
var cow_noises = [s1, s2, s3]
var cow_noises_played = -1
func get_next_cow_noise() -> Resource:
	cow_noises_played = cow_noises_played + 1
	return cow_noises[cow_noises_played]

func check_win() -> void:
	if $"Rows/1/Grave".cow_captured and $"Rows/2/Grave".cow_captured and $"Rows/3/Grave".cow_captured:
		$victory.visible = true
		Loggie.info("WIN")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for n:Node in get_tree().get_nodes_in_group("needs_main"):
		n.main = self

	$victory.visible = false
	$"Rows/1/Grave".show_necromancer()

	# randomize buff position
	var buffs = [0, 1, 2]
	buffs.shuffle()
	$"Rows/1/powerup".buff_type = buffs[0]
	$"Rows/2/powerup".buff_type = buffs[1]
	$"Rows/3/powerup".buff_type = buffs[2]

	#randomize cow sounds
	cow_noises.shuffle()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("1"):
		$"Rows/1/Grave".interact()
	if event.is_action_pressed("2"):
		$"Rows/2/Grave".interact()
	if event.is_action_pressed("3"):
		$"Rows/3/Grave".interact()

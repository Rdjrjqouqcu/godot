extends VBoxContainer


@export var player: Player

@onready var head: OptionButton = $HBoxContainer/head
@onready var body: OptionButton = $HBoxContainer2/body
@onready var leg: OptionButton = $HBoxContainer3/leg


var head_map: Dictionary[int, Head] = {}
var body_map: Dictionary[int, Body] = {}
var leg_map: Dictionary[int, Leg] = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	head.clear()
	for h in player.heads:
		head_map[head.item_count] = h
		head.add_item(h.name)
	head.select(0)
	body.clear()
	for h in player.bodies:
		body_map[body.item_count] = h
		body.add_item(h.name)
	body.select(0)
	leg.clear()
	for h in player.legs:
		leg_map[leg.item_count] = h
		leg.add_item(h.name)
	leg.select(0)
	update_selection()


func update_selection() -> void:
	player.select_set(
		head_map[head.selected],
		body_map[body.selected],
		leg_map[leg.selected],
	)


func _on_selection_changed(_index: int) -> void:
	update_selection()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

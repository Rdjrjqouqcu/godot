extends Node


var iron_ore: int = 0
var iron_ore_cap: int = 10

@onready var iron_label = $"../VBoxContainer/Resources/IronLabel"


func add_iron_ore():
	iron_ore = min(iron_ore + 1, iron_ore_cap)
	iron_label.text = str(iron_ore) + "/" + str(iron_ore_cap) + " Iron Ore"



func _on_ready():
	iron_label.text = str(iron_ore) + "/" + str(iron_ore_cap) + " Iron Ore"

extends Node

@export var health: int = 10
@export var max_health: int = 10

signal on_damage(target: Node, source: Node, dmg: int)
signal on_heal(target: Node, source: Node, heal: int)
signal on_death(target: Node, source: Node, dmg: int)

## ignores max_health and does not emit event
func override_health(amt: int):
	health = amt
	return self

func override_max_health(amt: int):
	max_health = amt
	return self

## sets health and max_health, does not emit event
func override_full_health(amt: int):
	health = amt
	max_health = amt
	return self

func is_dead():
	return health <= 0

func do_damage(dmg: int, source: Node):
	var parent = get_parent()
	health -= dmg
	on_damage.emit(parent, source, dmg)
	if is_dead():
		on_death.emit(parent, source, dmg)

func do_heal(heal: int, source: Node):
	var parent = get_parent()
	health = min(health + heal, max_health)
	on_heal.emit(parent, source, heal)

func _ready():
	pass # Replace with function body.


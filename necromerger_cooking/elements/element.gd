extends Resource

enum Element {
	AIR,
	FIRE,
	WATER,
	EARTH,
}

@export var name : String
@export var element: Element
@export var texture : Texture

@export var default_properties : Dictionary

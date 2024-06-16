extends RigidBody2D

enum Variations {
	MBS1,
	MBS2,
	MBT1,
	MBT2,
}

var VariationMap = {
	Variations.MBS1: init_brown_small_1,
	Variations.MBS2: init_brown_small_2,
	Variations.MBT1: init_brown_tiny_1,
	Variations.MBT2: init_brown_tiny_2,
}


#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_big1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_big2.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_big3.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_big4.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_med1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_med2.png"
var mbs1 = preload("res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_small1.png")
var mbs2 = preload("res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_small2.png")
var mbt1 = preload("res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_tiny1.png")
var mbt2 = preload("res://resources/SpaceShooterRedux/PNG/Meteors/meteorBrown_tiny2.png")
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_big1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_big2.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_big3.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_big4.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_med1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_med2.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_small1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_small2.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_tiny1.png"
#"res://resources/SpaceShooterRedux/PNG/Meteors/meteorGrey_tiny2.png"

func init_brown_small_1():
	if is_ready:
		sprite.set_texture(mbs1)
		collision.shape.set_radius(24)
		mass = 2
	else:
		selected = Variations.MBS1

func init_brown_small_2():
	if is_ready:
		sprite.set_texture(mbs2)
		collision.shape.set_radius(24)
		mass = 2
	else:
		selected = Variations.MBS2

func init_brown_tiny_1():
	if is_ready:
		sprite.set_texture(mbt1)
		collision.shape.set_radius(24)
		mass = 1
	else:
		selected = Variations.MBT1

func init_brown_tiny_2():
	if is_ready:
		sprite.set_texture(mbt2)
		collision.shape.set_radius(24)
		mass = 1
	else:
		selected = Variations.MBT2

@onready var health = $Health
@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite2D

var is_ready = false
var selected: Variations


# Called when the node enters the scene tree for the first time.
func _ready():
	is_ready = true
	VariationMap[selected].call()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

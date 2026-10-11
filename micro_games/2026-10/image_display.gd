extends TextureRect
class_name ImageDisplay


const _01_APPLE = preload("uid://bg66fq6oumkop")
const _02_RELIC = preload("uid://d3xipajxju12j")
const _03_MINIATURE = preload("uid://c25nrchv80ko6")
const _04_CACTUS = preload("uid://cuw77luu544et")
const _05_SMACK = preload("uid://vkk8lvt1w2dd")
const _06_FOX_OGRE_ = preload("uid://ialy1vdyb3uh")
const _07_PANIC = preload("uid://b5v5gtya3o1ra")
const _08_STINKY = preload("uid://dl3x61ok3hpt8")
const _09_RAM = preload("uid://boxhv50m1f1fq")

const map = {
	1: _01_APPLE,
	2: _02_RELIC,
	3: _03_MINIATURE,
	4: _04_CACTUS,
	5: _05_SMACK,
	6: _06_FOX_OGRE_,
	7: _07_PANIC,
	8: _08_STINKY,
	9: _09_RAM,
}

func show_img(id: int) -> void:
	if id <= 0 or id >= 10:
		return
	self.texture = map[id]
	self.visible = true


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			self.visible = false


func _on_day_select(event: InputEvent, id: int) -> void:
	if event is InputEventMouseButton:
		if event.pressed:
			show_img(id)

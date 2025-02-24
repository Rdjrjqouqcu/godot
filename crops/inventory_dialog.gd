extends PanelContainer

@onready var grid_container:GridContainer = %GridContainer


func _on_ready():
	hide()

func open(inventory:Inventory):
	show()


func _on_close_button_pressed():
	hide()

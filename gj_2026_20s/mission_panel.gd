extends PanelContainer
class_name MissionPanel

@export_group("missions", "mission_")

@export_custom(ETP.NONE, ETP.PROPERTY) var mission_1_text: String = "Stack on left pin":
	set(t):
		t = t.replace("\\n", "\n")
		mission_1_text = t
		mission_1_complete = t.is_empty()
		if text1: text1.text = t
		if mission_1: mission_1.visible = not t.is_empty()
@export_custom(ETP.NONE, ETP.PROPERTY) var mission_2_text: String = "Stack on middle pin":
	set(t):
		t = t.replace("\\n", "\n")
		mission_2_text = t
		mission_2_complete = t.is_empty()
		if text2: text2.text = t
		if mission_2: mission_2.visible = not t.is_empty()
@export_custom(ETP.NONE, ETP.PROPERTY) var mission_3_text: String = "Stack on right pin":
	set(t):
		t = t.replace("\\n", "\n")
		mission_3_text = t
		mission_3_complete = t.is_empty()
		if text3: text3.text = t
		if mission_3: mission_3.visible = not t.is_empty()

@onready var text1: Label = $MarginContainer/VBoxContainer/Mission1/Label
@onready var text2: Label = $MarginContainer/VBoxContainer/Mission2/Label
@onready var text3: Label = $MarginContainer/VBoxContainer/Mission3/Label

@onready var mission_1: HBoxContainer = $MarginContainer/VBoxContainer/Mission1
@onready var mission_2: HBoxContainer = $MarginContainer/VBoxContainer/Mission2
@onready var mission_3: HBoxContainer = $MarginContainer/VBoxContainer/Mission3

@onready var mission_1s: HSeparator = $MarginContainer/Strikethrough/Mission1s
@onready var mission_2s: HSeparator = $MarginContainer/Strikethrough/Mission2s
@onready var mission_3s: HSeparator = $MarginContainer/Strikethrough/Mission3s

const MOD_VISIBLE = Color.WHITE
const MOD_TRANSPARENT = Color.TRANSPARENT

@export_subgroup("start completed", "mission_")

@export_custom(ETP.NONE, ETP.PROPERTY) var mission_1_complete: bool = false:
	set(m):
		mission_1_complete = m
		if mission_1s: mission_1s.modulate = MOD_VISIBLE if m else MOD_TRANSPARENT
@export_custom(ETP.NONE, ETP.PROPERTY) var mission_2_complete: bool = false:
	set(m):
		mission_2_complete = m
		if mission_2s: mission_2s.modulate = MOD_VISIBLE if m else MOD_TRANSPARENT
@export_custom(ETP.NONE, ETP.PROPERTY) var mission_3_complete: bool = false:
	set(m):
		mission_3_complete = m
		if mission_3s: mission_3s.modulate = MOD_VISIBLE if m else MOD_TRANSPARENT


signal mission_complete(id: int)
signal mission_complete_all


func _ready() -> void:
	mission_1_text = mission_1_text
	mission_2_text = mission_2_text
	mission_3_text = mission_3_text


func mark_1(complete: bool) -> void:
	if mission_1_complete == complete: return
	mission_1_complete = complete
	if complete:
		mission_complete.emit(1)
		if mission_2_complete and mission_3_complete:
			mission_complete_all.emit()

func mark_2(complete: bool) -> void:
	if mission_2_complete == complete: return
	mission_2_complete = complete
	if complete:
		mission_complete.emit(2)
		if mission_1_complete and mission_3_complete:
			mission_complete_all.emit()

func mark_3(complete: bool) -> void:
	if mission_3_complete == complete: return
	mission_3_complete = complete
	if complete:
		mission_complete.emit(3)
		if mission_1_complete and mission_2_complete:
			mission_complete_all.emit()

func mark_by_id(id: int, complete: bool) -> void:
	match id:
		1: mark_1(complete)
		2: mark_2(complete)
		3: mark_3(complete)

func reset_completed() -> void:
	mission_1_complete = false
	mission_2_complete = false
	mission_3_complete = false

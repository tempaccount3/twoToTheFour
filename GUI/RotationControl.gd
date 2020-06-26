extends HBoxContainer

export var rot_id := -1
var value := Vector2(0, 0)

onready var dropdown := $Dropdown
onready var dropdown2 := $Dropdown2

signal rotation_changed(id, value)
signal rotation_removed(id)

func fill_dd(dd : OptionButton):
	dd.add_item("X", 0)
	dd.add_item("Y", 1)
	dd.add_item("Z", 2)
	dd.add_item("W", 3)

func _ready():
	fill_dd(dropdown)
	fill_dd(dropdown2)
	dropdown.selected = value.x
	dropdown2.selected = value.y

func emit_change():
	emit_signal("rotation_changed", rot_id, value)

func _on_Dropdown_item_selected(item_id):
	value.x = item_id
	emit_change()

func _on_Dropdown2_item_selected(item_id):
	value.y = item_id
	emit_change()


func _on_Delete_pressed():
	emit_signal("rotation_removed", rot_id)
	queue_free()

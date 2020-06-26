extends VBoxContainer

onready var hypercube := $"../Tesseract"
onready var camera := $"../Camera"
onready var rot_list := $RotationControlList

onready var rot_cache := preload("res://GUI/RotationControl.tscn")

func resize():
	rect_size = OS.window_size

func _on_HSlider_value_changed(value):
	camera.place_at_degree(value)

func _on_rotation_changed(id, plane):
	hypercube.update_rotation(id, plane.x, plane.y);
	hypercube.reset()

func _on_rotation_removed(id):
	hypercube.remove_rotation(id)
	hypercube.reset()

func add_new_rot(d1 := 0, d2 := 0):
	var rot := rot_cache.instance()
	_dev_null = rot.connect("rotation_changed", self, "_on_rotation_changed")
	_dev_null = rot.connect("rotation_removed", self, "_on_rotation_removed")
	var id : int = hypercube.add_rotation(d1, d2)
	rot.rot_id = id
	rot.value = Vector2(d1, d2)
	rot_list.add_child(rot)

func _ready():
	add_new_rot(0, 2)
	add_new_rot(1, 3)
	_dev_null = $"/root".connect("size_changed", self, "resize")
	#always at the end, just in case
	resize()

func _on_AddRotation_pressed():
	add_new_rot()

func _on_Button_pressed():
	hypercube.set_physics_process(!hypercube.is_physics_processing())

var _dev_null

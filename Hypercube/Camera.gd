extends Camera

export var rot_speed = 10
export var dist = 3

func _ready():
	translation.x = dist
	translation.y = 0
	translation.z = 0
	rotation_degrees.x = 0

func place_at_degree(deg : int):
	rotation_degrees.y = deg
	translation.x = sin(deg2rad(rotation_degrees.y)) * dist
	translation.z = cos(deg2rad(rotation_degrees.y)) * dist

func move(delta : float):
	rotation_degrees.y += rot_speed * delta
	translation.x = sin(deg2rad(rotation_degrees.y)) * dist
	translation.z = cos(deg2rad(rotation_degrees.y)) * dist

func _process(delta):
	move(delta)

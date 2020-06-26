extends Spatial

var base_points := []
var points := []
var projection := PoolVector3Array()
var lines := PoolVector3Array()

export var light_location : float = 1.1
export var tess_size : float = 2
export var rotation_speed : float = 0.5

onready var m := $MeshInstance
var arr_mesh := ArrayMesh.new()
var arrays := []

var rotations := {}
var rotation_id := -1

func create_tess(size := 1.0):
	points.resize(16)
	for i in range(16):
		points[i] = []
		points[i].resize(4)
		var c = i
		for j in range(4):
			points[i][j] = (c % 2 - 0.5) * size
			c /= 2
	base_points = points.duplicate(true)

func rotate_plane(theta : float, d1 := 0, d2 := 1):
	if (d1 == d2):
		return
	var temp : float
	var c := cos(theta)
	var s := sin(theta)
	for point in points:
		temp = point[d1]
		point[d1] = point[d1] * c - point[d2] * s
		point[d2] = temp * s + point[d2] * c

func execute_rotations(delta : float):
	for rot in rotations.values():
		rotate_plane(delta, rot.x, rot.y)

#returns assigned id
func add_rotation(d1 : int, d2 : int) -> int:
	rotation_id += 1
	rotations[rotation_id] = Vector2(d1, d2)
	return rotation_id

func update_rotation(id : int, d1 : int, d2 : int):
	rotations[id] = Vector2(d1, d2)

func remove_rotation(id : int):
	_dev_null = rotations.erase(id)

func reset():
	points = base_points.duplicate(true)

#returns range of z-coordinate
func project(_d := 0.0) -> Vector2:
	var min_z := 0.0
	var max_z := 0.0
	var coefficient : float
	for i in range(16):
		#in this code we don't stand divisions by zero
		if (light_location == points[i][3]):
			light_location += 0.001
		coefficient = (light_location - points[i][3])
		for j in range(3):
			projection[i][j] = points[i][j] / coefficient
		if (projection[i][2] < min_z):
			min_z = projection[i][2]
		elif (projection[i][2] > max_z):
			max_z = projection[i][2]
	return Vector2(min_z, max_z)

func update_lines():
	var count : int = 0
	#horizontal
	for i in range(0, 16, 2):
		lines[count] = projection[i]
		lines[count + 1] = projection[i + 1]
		count += 2
	#vertical
	for i in range(0, 16, 4):
		#left
		lines[count] = projection[i]
		lines[count + 1] = projection[i + 2]
		#right
		lines[count + 2] = projection[i + 1]
		lines[count + 3] = projection[i + 3]
		count += 4
	#depth
	for i in range(4):
		#cube1
		lines[count] = projection[i]
		lines[count + 1] = projection[i + 4]
		#cube2
		lines[count + 2] = projection[i + 8]
		lines[count + 3] = projection[i + 12]
		count += 4
	#4d
	for i in range(8):
		lines[count] = projection[i]
		lines[count + 1] = projection[i + 8]
		count += 2

func update_mesh():
	arrays[ArrayMesh.ARRAY_VERTEX] = lines
	arr_mesh.surface_remove(0)
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)

func draw():
	#project and update shader together
	m.material_override.set_shader_param("border", project())
	update_lines()
	update_mesh()

func _ready():
	create_tess()
	projection.resize(16)
	_dev_null = project()
	lines.resize(64)
	update_lines()
	
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = lines
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, arrays)
	m.mesh = arr_mesh
	
	#debug zone
	

func _physics_process(delta):
	execute_rotations(delta * rotation_speed)
	draw()

var _dev_null

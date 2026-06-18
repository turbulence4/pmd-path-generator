@tool
extends MeshInstance3D

var size := 1024.0
@export_range(4, 256, 4) var resolution := 32:
	set(newResolution):
		resolution = newResolution
		updateMesh()

@export_range(4.0, 128.0, 4.0) var height := 64.0:
	set(newHeight):
		material_override.set_shader_parameter("height", height * 2)
		height = newHeight
		updateMesh()

@export var noise: FastNoiseLite:
	set(newNoise):
		noise = newNoise
		if noise:
			noise.changed.connect(updateMesh)

func _ready() -> void:
	noise.seed = randi()
	updateMesh()

func getHeight(x: float, z: float) -> float:
	return noise.get_noise_2d(x, z) * height

func getNormal(x: float, z: float) -> Vector3:
	var epsilon := size / resolution #the distance between adj verts in plane
	var normal := Vector3(
		(getHeight(x + epsilon, z) - getHeight(x - epsilon, z)) / (2.0 * epsilon), 
		1.0,
 		(getHeight(x, z + epsilon) - getHeight(x, z - epsilon)) / (2.0 * epsilon),
	)
	
	return normal.normalized()

func updateMesh():
	var plane := PlaneMesh.new()
	plane.subdivide_depth = resolution
	plane.subdivide_width = resolution
	plane.size = Vector2(size, size)
	
	var planeArrays := plane.get_mesh_arrays()
	var vertexArray: PackedVector3Array = planeArrays[ArrayMesh.ARRAY_VERTEX]
	var normalArray: PackedVector3Array = planeArrays[ArrayMesh.ARRAY_NORMAL]
	var tangentArray: PackedFloat32Array = planeArrays[ArrayMesh.ARRAY_TANGENT]
	
	for i: int in vertexArray.size():
		var vertex := vertexArray[i]
		var normal := Vector3.UP
		var tangent := Vector3.RIGHT
		if noise:
			vertex.y = getHeight(vertex.x, vertex.z)
			normal = getNormal(vertex.x, vertex.z)
			tangent = normal.cross(Vector3.UP)
		vertexArray[i] = vertex
		normalArray[i] = normal
		tangentArray[4 * i] = tangent.x
		tangentArray[4 * i + 1] = tangent.y
		tangentArray[4 * i + 2] = tangent.z
	
	var arrayMesh := ArrayMesh.new()
	arrayMesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, planeArrays)
	mesh = arrayMesh

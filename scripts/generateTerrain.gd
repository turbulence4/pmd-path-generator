extends MeshInstance3D

@export var perlinScale = 3
@export var numVertX = 10
@export var numVertZ = 10

func _ready() -> void:
	generateTerrain()

func generateTerrain():
	var surfaceArray = []
	surfaceArray.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	var noise = FastNoiseLite.new()
	
	#prodgen code here
	var noiseImage = noise.get_image(100, 100, false, true, true)
	
	#make a square 300x300 units with 100x100 verts every 3 units
	for z in range(numVertZ):
		for x in range(numVertX):
			verts.append(Vector3(x * perlinScale, 0, z * perlinScale))
			normals.append(Vector3.UP)
			uvs.append(Vector2(x, z))
	
	for z in range(numVertZ - 1):
		for x in range(numVertX):
			var v0 = z * numVertX + x
			var v1 = v0 + 1
			var v2 = v0 + numVertX
			var v3 = v2 + 1
			
			indices.append(v0)
			indices.append(v2)
			indices.append(v1)
			
			indices.append(v2)
			indices.append(v3)
			indices.append(v1)
	
	surfaceArray[Mesh.ARRAY_VERTEX] = verts
	surfaceArray[Mesh.ARRAY_TEX_UV] = uvs
	surfaceArray[Mesh.ARRAY_NORMAL] = normals
	surfaceArray[Mesh.ARRAY_INDEX] = indices
	
	print(verts)
	print(indices)
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_LINES, surfaceArray)

extends Node

@onready var mesh = $"."

func _ready() -> void:
	generateTerrain()

func generateTerrain():
	var surfaceArray = []
	surfaceArray.resize(Mesh.ARRAY_MAX)
	
	var verts = PackedVector3Array()
	var uvs = PackedVector2Array()
	var normals = PackedVector3Array()
	var indices = PackedInt32Array()
	
	surfaceArray[Mesh.ARRAY_VERTEX] = verts
	surfaceArray[Mesh.ARRAY_TEX_UV] = uvs
	surfaceArray[Mesh.ARRAY_NORMAL] = normals
	surfaceArray[Mesh.ARRAY_INDEX] = indices
	
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surfaceArray)

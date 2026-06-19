extends Path3D

@onready var path = $"."
var random := RandomNumberGenerator.new()
var numPoints := int(random.randf_range(15, 150))

@export var minSegLength := 3.0
@export var maxSegLength := 20.0
@export var minAngle := -PI/4
@export var maxAngle := PI/4

@onready var terrain = $"../terrain"

func _ready() -> void:
	generatePath()

func getHeightFromTerrain(x: float, z: float) -> float:
	#not really sure how i'm going to do this. either shoot a ray down and see where it intersects or get the noise somehow
	return 0.0

func generatePath():
	var pathPointX := 0.0
	var pathPointZ := 0.0
	var cumAngle := random.randf_range(0, TAU)
	
	for i in numPoints:
		cumAngle += random.randf_range(minAngle, maxAngle)
		pathPointX += random.randf_range(minSegLength / $CSGPolygon3D.scale.x, maxSegLength / $CSGPolygon3D.scale.x) * cos(cumAngle)
		pathPointZ += random.randf_range(minSegLength / $CSGPolygon3D.scale.z, maxSegLength / $CSGPolygon3D.scale.z) * sin(cumAngle)
		path.curve.add_point(Vector3(pathPointX, getHeightFromTerrain(pathPointX, pathPointZ), pathPointZ), Vector3.ZERO, Vector3.ZERO, i + 1)


func _on_ui_regenerate_trail() -> void:
	path.curve.clear_points()
	generatePath()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("f"):
		path.curve.clear_points()
		generatePath()

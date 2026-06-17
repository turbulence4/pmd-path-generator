extends Path3D

@onready var path = $"."
var random := RandomNumberGenerator.new()
var numPoints := int(random.randf_range(15, 150))

@export var minSegLength := 3.0
@export var maxSegLength := 20.0
@export var minAngle := -PI/4
@export var maxAngle := PI/4

func _ready() -> void:
	generatePath()

func regenerateTrail():
	print("lalala")

func generatePath():
	var pathPointX := 0.0
	var pathPointZ := 0.0
	var cumAngle := random.randf_range(0, TAU)
	
	for i in numPoints:
		cumAngle += random.randf_range(minAngle, maxAngle)
		pathPointX += random.randf_range(minSegLength / $CSGPolygon3D.scale.x, maxSegLength / $CSGPolygon3D.scale.x) * cos(cumAngle)
		pathPointZ += random.randf_range(minSegLength / $CSGPolygon3D.scale.z, maxSegLength / $CSGPolygon3D.scale.z) * sin(cumAngle)
		path.curve.add_point(Vector3(pathPointX, 0, pathPointZ), Vector3.ZERO, Vector3.ZERO, i + 1)


func _on_ui_regenerate_trail() -> void:
	path.curve.clear_points()
	generatePath()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("f"):
		path.curve.clear_points()
		generatePath()

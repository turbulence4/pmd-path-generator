extends Path3D

@onready var path = $"."
var random := RandomNumberGenerator.new()
var numPoints := random.randi_range(15, 50)

@export var minSegLength := 3.0
@export var maxSegLength := 20.0
@export var minAngle := -PI/4
@export var maxAngle := PI/4

@onready var terrain = $"../terrain"

func _ready() -> void:
	generatePath()

func getHeightFromTerrain(x: float, z: float) -> float:
	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(Vector3(x, 1000, z), Vector3(x, -1000, z))
	var result = space_state.intersect_ray(query)
	
	if result:
		var sphere := MeshInstance3D.new()
		sphere.mesh = SphereMesh.new()
		sphere.scale = Vector3.ONE * 12
		sphere.global_position = result.position
		add_child(sphere)
		return result.position.y
	else:
		return 0.0

func generatePath():
	var pathPointX := 0.0
	var pathPointZ := 0.0
	var cumAngle := random.randf_range(0, TAU)
	
	for i in numPoints:
		cumAngle += random.randf_range(minAngle, maxAngle)
		pathPointX += random.randf_range(minSegLength, maxSegLength) * cos(cumAngle)
		pathPointZ += random.randf_range(minSegLength, maxSegLength) * sin(cumAngle)
		
		var worldPos = path.to_global(Vector3(pathPointX, 0, pathPointZ))
		var height = getHeightFromTerrain(worldPos.x, worldPos.z)
		path.curve.add_point(Vector3(worldPos.x, height, worldPos.z), Vector3.ZERO, Vector3.ZERO, i + 1)
		
		var posDisplay: Label3D = Label3D.new()
		posDisplay.global_position = path.to_global(path.curve.get_point_position(i))
		posDisplay.text = str(posDisplay.position)
		posDisplay.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		posDisplay.font_size = 200
		add_child(posDisplay)

func _on_ui_regenerate_trail() -> void:
	path.curve.clear_points()
	generatePath()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("f"):
		path.curve.clear_points()
		generatePath()
	if Input.is_action_just_pressed("q"):
		$"../terrain".visible = !$"../terrain".visible

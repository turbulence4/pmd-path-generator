extends Node3D

@export var speed := 25
@export var sprintSpeed := speed * 2
@export var camSpeed := 0.3
@export var minAngle := -PI/2
@export var maxAngle := PI/2
var curSpeed = speed
var velocity := Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	input(delta)

func input(delta: float):
	#sprinting
	if Input.is_action_pressed("ctrl"):
		curSpeed = sprintSpeed
	else:
		curSpeed = speed
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var vertical_dir := Input.get_axis("shift", "space")
	var direction := (transform.basis * Vector3(input_dir.x, vertical_dir, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * curSpeed * delta
		velocity.y = direction.y * curSpeed * delta
		velocity.z = direction.z * curSpeed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, curSpeed)
		velocity.y = move_toward(velocity.y, 0, curSpeed)
		velocity.z = move_toward(velocity.z, 0, curSpeed)
	
	position += velocity

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(event.relative.x * -0.01 * camSpeed)
			$Camera3D.rotate_x(event.relative.y * -0.01 * camSpeed)
			$Camera3D.rotation.x = clampf($Camera3D.rotation.x, minAngle, maxAngle)

extends CharacterBody3D

@export var speed := 5.0
@export var jump_velocity := 9
@export var gravity := 20
@export var mouse_sensitivity := 0.002

var head_rotation := Vector2.ZERO
@onready var camera_3d: Camera3D = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head_rotation.x -= event.relative.x * mouse_sensitivity
		head_rotation.y -= event.relative.y * mouse_sensitivity
		head_rotation.y = clamp(head_rotation.y, -1.5, 1.5)

		rotation.y = head_rotation.x
		camera_3d.rotation.x = head_rotation.y

func _physics_process(delta):
	var input_dir = Vector3.ZERO

	if Input.is_action_pressed("move_forward"):
		input_dir.z -= 1
	if Input.is_action_pressed("move_back"):
		input_dir.z += 1
	if Input.is_action_pressed("move_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("move_right"):
		input_dir.x += 1
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()

	input_dir = input_dir.normalized()
	var direction = (global_transform.basis * input_dir).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0.0
		if Input.is_action_just_pressed("jump"):
			velocity.y = jump_velocity

	move_and_slide()

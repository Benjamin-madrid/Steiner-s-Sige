extends CharacterBody3D

@export var footstep_scene: PackedScene
@onready var spawner = $FootstepSpawner

@export var move_speed := 2.0
@export var footstep_distance := 1.0

var direction = Vector3.FORWARD
var moving_forward = true
var last_footstep_position: Vector3

func _ready():
	last_footstep_position = global_transform.origin

func _physics_process(_delta):
	if moving_forward:
		velocity = direction * move_speed
	else:
		velocity = -direction * move_speed
	
	move_and_slide()

	var distance = global_transform.origin.distance_to(last_footstep_position)
	if distance >= footstep_distance:
		_spawn_footstep()
		last_footstep_position = global_transform.origin

	if moving_forward and global_transform.origin.z <= -5:
		moving_forward = false
	elif not moving_forward and global_transform.origin.z >= 0:
		moving_forward = true

func _spawn_footstep():
	if not footstep_scene:
		return

	var step = footstep_scene.instantiate()
	spawner.add_child(step)
	step.global_transform.origin = global_transform.origin - Vector3(0, 1.5, 0)

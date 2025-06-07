class_name Enemy extends CharacterBody3D

# Footsteps, navigation agent and deteccion areas
@onready var spawner = $FootstepSpawner
@onready var navigationAgent : NavigationAgent3D = $NavigationAgent3D
@onready var delimiters = get_tree().get_nodes_in_group("MapLimits")
@onready var enemy_hearing: Area3D = $EnemyHearing

# Enemy states
var Patrol: EnemyStates = preload("res://scripts/states/enemy_states/patrol.gd").new()
var Searching: EnemyStates = preload("res://scripts/states/enemy_states/searching.gd").new()
var Waiting: EnemyStates = preload("res://scripts/states/enemy_states/waiting.gd").new()
var Hunting: EnemyStates = preload("res://scripts/states/enemy_states/hunting.gd").new()
# 
@export var move_speed := 2.0
@export var footstep_scene: PackedScene
@export var footstep_distance := 1.0

var last_footstep_position: Vector3
var min_limit: Vector3
var max_limit: Vector3
var player: CharacterBody3D


# Current enemy state
var state: EnemyStates

# Changes the current state for a given new one
func setState(newState: EnemyStates):
	state = newState
	state.stateEnter(self)

func _ready():
	last_footstep_position = global_transform.origin
	for limit in delimiters:
		var limit_pos = limit.global_position
		min_limit = min_limit.min(limit_pos)
		max_limit = max_limit.max(limit_pos)
	setState(Waiting)

func _physics_process(delta):
	if player:
		$VisionRayCast.look_at(player.global_transform.origin, Vector3.UP)
		if $VisionRayCast.is_colliding():
			var collider = $VisionRayCast.get_collider()
			if collider.is_in_group("Player"):
				if !(state == Hunting):
					setState(Hunting)

	if state:
		state.update(self)
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()

	var distance = global_transform.origin.distance_to(last_footstep_position)
	if distance >= footstep_distance:
		_spawn_footstep()
		last_footstep_position = global_transform.origin

func _spawn_footstep():
	if not footstep_scene:
		return

	var step = footstep_scene.instantiate()
	spawner.add_child(step)
	step.global_transform.origin = global_transform.origin - Vector3(0, 0, 0)

func _on_EnemyHearing_entered(body):
	if body.has_signal("noise_emitted"):
		body.connect("noise_emitted", Callable(self, "_on_sound_heard"))
		
func _on_HearingArea_body_exited(body):
	if body.has_signal("noise_emitted"):
		body.disconnect("noise_emitted", Callable(self, "_on_sound_heard"))

func _on_sound_heard(sound_pos: Vector3):
	var nav_map = navigationAgent.get_navigation_map()
	var targetPos = NavigationServer3D.map_get_closest_point(nav_map, sound_pos)
	navigationAgent.set_target_position(targetPos)
	setState(Searching)

func move_towards(targetPos):
	targetPos.y = global_position.y
	var direction = global_position.direction_to(targetPos)
	if direction != Vector3.ZERO:
		var view = global_position + direction
		look_at(view, Vector3.UP)
	velocity = direction * move_speed


func _on_enemy_sight_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = body


func _on_enemy_sight_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		player = null

extends RigidBody3D

signal noise_emitted(pos: Vector3)

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export var HitSoundWAV: AudioStream

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _on_body_entered(_body):
	if HitSoundWAV:
		audio_stream_player_3d.stream = HitSoundWAV
		audio_stream_player_3d.play()
	emit_signal("noise_emitted", global_transform.origin)

func Interact():
	get_tree().get_nodes_in_group("Player")[0].GrabObject(self)

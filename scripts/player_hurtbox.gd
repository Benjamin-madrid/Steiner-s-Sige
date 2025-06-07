class_name Hurtbox
extends Area3D

signal hurtbox_hit

@onready var parent = null


func _ready() -> void:
	area_entered.connect(_on_hitbox_entered)
	
func _on_hitbox_entered(area: Area3D) -> void:
	if area is Hitbox:
		emit_signal("hurtbox_hit")
		

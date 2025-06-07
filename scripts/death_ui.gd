extends MarginContainer

@onready var restart: Button = %Restart
@onready var main_menu: Button = %MainMenu

func _ready() -> void:
	hide()
	restart.pressed.connect(_on_restart_pressed)
	main_menu.pressed.connect(_on_main_menu_pressed)
	
func _on_restart_pressed() -> void:
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().reload_current_scene()
	
func _on_main_menu_pressed() -> void:
	pass

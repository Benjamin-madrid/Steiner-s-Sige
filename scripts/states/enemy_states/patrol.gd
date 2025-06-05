extends EnemyStates

func stateEnter(enemy):
	enemy.navigationAgent.set_target_position(_get_random_patrol_point(enemy))
	
func update(enemy):
	if enemy.navigationAgent.is_navigation_finished():
		enemy.navigationAgent.set_target_position(_get_random_patrol_point(enemy))
	enemy.move_towards(enemy.navigationAgent.get_next_path_position())
	
func _get_random_patrol_point(enemy) -> Vector3:
	var x = randf_range(enemy.min_limit.x, enemy.max_limit.x)
	var z = randf_range(enemy.min_limit.z, enemy.max_limit.z)
	var y = enemy.min_limit.y
	var raw_pos = Vector3(x, y, z)
	var nav_map = enemy.navigationAgent.get_navigation_map()
	return NavigationServer3D.map_get_closest_point(nav_map, raw_pos)

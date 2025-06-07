extends EnemyStates

func stateEnter(enemy: Enemy):
	var player_pos = enemy.player.global_transform.origin
	var nav_map = enemy.navigationAgent.get_navigation_map()
	var closest_point = NavigationServer3D.map_get_closest_point(nav_map, player_pos)
	enemy.navigationAgent.set_target_position(closest_point)
	enemy.move_speed += 1.5

func update(enemy: Enemy):
	if enemy.navigationAgent.is_navigation_finished():
		enemy.move_speed -= 1.5
		enemy.setState(enemy.Waiting)
	else:
		enemy.move_towards(enemy.navigationAgent.get_next_path_position())

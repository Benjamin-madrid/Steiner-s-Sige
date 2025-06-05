extends EnemyStates
	
func update(enemy: Enemy):
	if enemy.navigationAgent.is_navigation_finished():
		enemy.setState(enemy.Waiting)
	else:
		enemy.move_towards(enemy.navigationAgent.get_next_path_position())

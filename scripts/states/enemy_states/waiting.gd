extends EnemyStates

var timer := 1.5
var elapsed := 0.0

func stateEnter(enemy: Enemy):
	enemy.velocity = Vector3.ZERO
	elapsed = 0.0

func update(enemy: Enemy):
	elapsed += enemy.get_process_delta_time()
	if elapsed >= timer:
		enemy.setState(enemy.Patrol)

extends Node2D

@onready var combat_log = $CombatLog



func _check_win():
	
	var totalAllies = get_tree().get_node_count_in_group("AllyToken")
	var totalEnemies = get_tree().get_node_count_in_group("EnemyToken")
	if totalAllies == 0:
		SceneTransition._transition()
		await SceneTransition.on_transition_finished
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	elif totalEnemies == 0:
		queue_free()
	else:
		pass

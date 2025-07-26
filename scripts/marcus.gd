extends BaseAllyToken

func _ready() -> void:
	if GlobalVariables.acceptedMarcusHelp == false:
		queue_free()
	$statSetter.start()

func _on_timer_timeout():
	_choose_action()


func _on_update_target_timeout() -> void:
	if get_tree().get_node_count_in_group("EnemyToken") == 0:
		pass
	else:
		var availableTargets = get_tree().get_nodes_in_group("EnemyToken")
		targetToChase = availableTargets.pick_random()
		navigationAgent.target_position = targetToChase.global_position


func _on_stat_setter_timeout() -> void:
	_set_stats()

extends BaseTokenEnemy



func _on_timer_timeout():
	_choose_action()


func _on_get_target_timer_timeout() -> void:
	combatShouts.text = ""
	if get_tree().get_node_count_in_group("AllyToken") == 0:
		pass
	else:
		targetToChase = get_tree().get_first_node_in_group("AllyToken")
		navigationAgent.target_position = targetToChase.global_position

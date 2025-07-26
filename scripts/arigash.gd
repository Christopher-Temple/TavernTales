extends BaseTokenEnemy



func _combat_shouts():
	var combatShout = randi_range(1,3)
	if combatShout == 1:
		combatShout.text = "You will join my collection!"
	elif combatShout == 2:
		combatShout.text = ""
	elif combatShout == 3:
		combatShout.text = "My zombies will drag you into my embrace."
	else:
		pass
	actionTimer.start(randi_range(1,3))
	
func _on_timer_timeout():
	_choose_action()

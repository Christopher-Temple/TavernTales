extends EnemyProjectile

	
func _on_area_2d_body_entered(body):
	if body.is_in_group("AllyToken"):
		var damage = randi_range(minimumDamage,maximumDamage)
		body._take_damage(damage)
		get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(body.tokenName+" is stuck by an "+projectileName+" for "+str(damage)+" damage")
		get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
		$AudioStreamPlayer2D.play()
		await get_tree().create_timer(0.05).timeout
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

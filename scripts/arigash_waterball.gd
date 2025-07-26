extends EnemyProjectile

func _ready() -> void:
	$fire.play()
	
func _on_area_2d_body_entered(body):
	if body.is_in_group("AllyToken"):
		$burst.play()
		await get_tree().create_timer(0.05).timeout
		var damage = randi_range(minimumDamage,maximumDamage)
		body._take_damage(damage)
		get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(body.tokenName+" is hit by "+projectileName+" for "+str(damage)+" damage")
		get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

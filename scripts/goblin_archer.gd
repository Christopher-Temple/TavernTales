extends BaseTokenEnemy


func _physics_process(_delta):
	move_and_slide()


func _on_timer_timeout():
	_choose_action()

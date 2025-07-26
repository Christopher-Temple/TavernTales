extends Control


func _on_create_character_pressed():
	$Accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/character_creator.tscn")

func _on_return_pressed():
	$Accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/title.tscn")

func _on_choose_adventure_pressed() -> void:
	$Accept.play()
	SceneTransition._transition()
	await SceneTransition.on_transition_finished
	get_tree().change_scene_to_file("res://scenes/adventure_selection.tscn")

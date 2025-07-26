extends Control



@onready var object_container = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer
@onready var scroll_container = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer

@onready var texture_rect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect
@onready var texture_rect_2 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect2
@onready var texture_rect_3 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect3
@onready var texture_rect_4 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect4
@onready var texture_rect_5 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect5
@onready var texture_rect_6 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect6
@onready var texture_rect_7 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect7
@onready var texture_rect_8 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect8
@onready var texture_rect_9 = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/ScrollContainer/ObjectContainer/TextureRect9



var adventureNames = ["The Goblin King", "Crazed Kobolds", "Dire Situation", "Awake the Dead", "Calamity", "Bandit Bounty", "Red Dragon's Stash", "Heart of the Pheniox", "Don't Haggle With Hags"]

var targetScroll = 0
var adventureOption = 0

func _ready() -> void:
	_set_selection()
	_set_text()


func _set_selection():
	await get_tree().create_timer(0.01).timeout
	_select_deselect_highlight()

func _start_the_bounce():
	_hover_selected_up(adventureOption)

func _on_previous_button_pressed() -> void:
	if adventureOption >= 1:
		$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/PreviousButton.disabled = true
		var scrollValue = targetScroll - _get_space_between()
		await _tween_scroll(scrollValue)
		_select_deselect_highlight()
		adventureOption -= 1
		_set_text()
		$EnableScroll.start()
	else:
		pass

func _on_next_button_pressed() -> void:
	if adventureOption <= 7:
		$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect2/NextButton.disabled = true
		var scrollValue = targetScroll + _get_space_between()
		await _tween_scroll(scrollValue)
		_select_deselect_highlight()
		adventureOption += 1
		_set_text()
		$EnableScroll.start()
	else:
		pass

func _get_space_between():
	var distanceSize = object_container.get_theme_constant("separation")
	var objectSize = object_container.get_children()[1].size.x
	
	return distanceSize + objectSize
	
func _tween_scroll(scrollValue):
	targetScroll = scrollValue
	
	var tween = get_tree().create_tween()
	tween.tween_property(scroll_container, "scroll_horizontal", scrollValue, 0.50)
	
	await tween.finished

func _select_deselect_highlight():
	var selectedNode = _get_selected_value()
	
	for object in object_container.get_children():
		if object is not TextureRect:
			continue
		if object == selectedNode:
			object.modulate = Color(1,1,1)
		else:
			object.modulate = Color(0.2,0.2,0.2)
			
func _get_selected_value():
	var selectedPosition = %SelectionMarker.global_position
	
	for object in object_container.get_children():
		if object.get_global_rect().has_point(selectedPosition):
			return object

func _hover_selected_up(bounceTarget):
	if adventureOption <= 0:
		bounceTarget = texture_rect
	elif adventureOption == 1:
		bounceTarget = texture_rect_2
	elif adventureOption == 2:
		bounceTarget = texture_rect_3
	elif adventureOption == 3:
		bounceTarget = texture_rect_4
	elif adventureOption == 4:
		bounceTarget = texture_rect_5
	elif adventureOption == 5:
		bounceTarget = texture_rect_6
	elif adventureOption == 6:
		bounceTarget = texture_rect_7
	elif adventureOption == 7:
		bounceTarget = texture_rect_8
	elif adventureOption >= 8:
		bounceTarget = texture_rect_9
	var hoverTween = get_tree().create_tween()
	
	hoverTween.tween_property(bounceTarget, "position",Vector2.UP*2, 0.3).as_relative().set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.31).timeout
	_hover_selected_down(adventureOption)
	
func _hover_selected_down(bounceTarget):
	if adventureOption <= 0:
		bounceTarget = texture_rect
	elif adventureOption == 1:
		bounceTarget = texture_rect_2
	elif adventureOption == 2:
		bounceTarget = texture_rect_3
	elif adventureOption == 3:
		bounceTarget = texture_rect_4
	elif adventureOption == 4:
		bounceTarget = texture_rect_5
	elif adventureOption == 5:
		bounceTarget = texture_rect_6
	elif adventureOption == 6:
		bounceTarget = texture_rect_7
	elif adventureOption == 7:
		bounceTarget = texture_rect_8
	elif adventureOption >= 8:
		bounceTarget = texture_rect_9
	var hoverTween = get_tree().create_tween()
	
	hoverTween.tween_property(bounceTarget, "position", Vector2.DOWN*2, 0.3).as_relative().set_trans(Tween.TRANS_SINE)
	await get_tree().create_timer(0.31).timeout
	_hover_selected_up(adventureOption)

func _on_adventure_selection_button_pressed():
	if adventureOption == 0 and GlobalVariables.characterChosen == true:
		$Click.play()
		SceneTransition._transition()
		await SceneTransition.on_transition_finished
		GlobalVariables.adventureName = "The Goblin King"
		get_tree().change_scene_to_file("res://scenes/adventure_one.tscn")
	else:
		$AdventureSelectionButton/RichTextLabel.show()
		$AdventureSelectionButton/RichTextLabel/Timer.start()


func _on_timer_timeout() -> void:
	$AdventureSelectionButton/RichTextLabel.hide()

func _set_text():
	if adventureOption in range(0,3):
		$Difficulty.text = "[center]Heroic Tale"
		$Difficulty.set("theme_override_colors/default_color", "green")
		$Title.text = "[center]" + adventureNames[adventureOption]
	elif adventureOption in range(3,6):
		$Difficulty.text = "[center]Epic Adventure"
		$Difficulty.set("theme_override_colors/default_color", "5E89FF")
		$Title.text = "[center]" + adventureNames[adventureOption]
	elif adventureOption in range(6,9):
		$Difficulty.text = "[center][rainbow]Legendary Fable"
		$Difficulty.set("theme_override_colors/default_color", "red")
		$Title.text = "[center]" + adventureNames[adventureOption]
	


func _on_enable_scroll_timeout():
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect2/NextButton.disabled = false
	$PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/TextureRect/PreviousButton.disabled = false

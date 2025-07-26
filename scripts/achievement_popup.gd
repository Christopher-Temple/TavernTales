extends Control

@onready var description: RichTextLabel = $TextureRect/description
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ach_popup(achDescription):
	description.text = "[center]"+achDescription
	animation_player.play("Popup")

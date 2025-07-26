extends Control

@onready var panel = $Panel
@onready var textLabel = $Panel/MarginContainer/RichTextLabel
@onready var titleLabel = $RichTextLabel2

func Config(for_text):
	#if not textLabel:
		#await self.ready
	
	textLabel = for_text

# All this does is get rid of the background on the tooltip's viewport
func _enter_tree() -> void:
	var par=get_parent()
	var panel_n=StyleBoxLine.new()
	panel_n.color=Color(0,0,0,0)
	par.set_indexed("theme_override_styles/panel",panel_n)
	#get_viewport().transparent_bg=true
	par.transparent=true

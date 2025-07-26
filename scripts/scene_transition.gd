extends CanvasLayer

@onready var colorRect = $ColorRect
@onready var animationPlayer = $ColorRect/AnimationPlayer

signal on_transition_finished


# Called when the node enters the scene tree for the first time.
func _ready():
	colorRect.visible = false
	animationPlayer.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(animationChoice):
	if animationChoice == "fade_to_black":
		on_transition_finished.emit()
		animationPlayer.play("fade_to_normal")
	elif animationChoice == "fade_to_normal":
		colorRect.visible = false

func _transition():
	colorRect.visible = true
	animationPlayer.play("fade_to_black")
	

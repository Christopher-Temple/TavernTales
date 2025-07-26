extends CharacterBody2D
class_name EnemyProjectile

@export var projectileSpeed : int
@export var projectileName : String
@export var minimumDamage : int
@export var maximumDamage : int


var dir : Vector2
var pos : Vector2

func _ready():
	global_position = pos

func _physics_process(delta):
	velocity = dir * projectileSpeed
	move_and_slide()

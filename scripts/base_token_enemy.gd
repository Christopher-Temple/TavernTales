extends CharacterBody2D
class_name BaseTokenEnemy

@export var damageMinimum : int
@export var damageMaximum : int
@onready var tokenHealth : int
@onready var tokenMana: int
@export var tokenName : String
@export var tokenStrength : int
@export var tokenDexterity : int
@export var tokenWisdom : int
@export var tokenConstitution : int
@export var tokenCharisma : int
@export var tokenSpeed : int
@export var rangedProjectile : PackedScene
@export var magicProjectile : PackedScene
@export var manaCost : int
@export var healthBar : ProgressBar
@export var manaBar : ProgressBar
@export var nameTag : RichTextLabel
@export var specialName : String
@export var combatShouts : RichTextLabel
@export var actionTimer : Timer
@export var hurtNoise : AudioStreamPlayer2D
@export var animationPlayer : AnimationPlayer
@export var marker : Marker2D
@export var meleeArea : Area2D
@export var targetToChase : CharacterBody2D
@export var navigationAgent : NavigationAgent2D
@export var animatedSprite : AnimatedSprite2D
@export var tokenSelf : CharacterBody2D
@export var collisionShape : CollisionShape2D

@export var hasMelee : bool
@export var hasRanged : bool
@export var hasMagic : bool
@export var canChase : bool

var attackOptions = []

func _physics_process(_delta):
	velocity = global_position.direction_to(navigationAgent.get_next_path_position()) * tokenSpeed
	if velocity.x > 0:
		animatedSprite.flip_h = true
	elif velocity.x < 0:
		animatedSprite.flip_h = false
	move_and_slide()
	

func _ready() -> void:
	tokenHealth = tokenConstitution * 5
	tokenMana = tokenWisdom * 5
	healthBar.max_value = tokenHealth
	healthBar.value = tokenHealth
	nameTag.text = specialName+tokenName
	manaBar.max_value = tokenMana
	manaBar.value = tokenMana
	if hasMagic:
		attackOptions.append("_magic_attack")
	if hasMelee:
		attackOptions.append("_melee_attack")
	if hasRanged:
		attackOptions.append("_ranged_attack")

func _take_damage(damageDealt):
	_set_health(damageDealt)
	hurtNoise.play()
	animationPlayer.play("damaged")
	
func _set_health(value):
	
	healthBar.value -= value
	if healthBar.value <= 0:
		if tokenSelf.is_in_group("EnemyToken"):
			tokenSelf.remove_from_group("EnemyToken")
		actionTimer.stop()
		animationPlayer.stop()
		death()

func death():
	set_physics_process(false)
	collisionShape.disabled = true
	animatedSprite.play("death")
	nameTag.hide()
	manaBar.hide()
	healthBar.hide()
	meleeArea.hide()
	await get_tree().create_timer(2).timeout
	animationPlayer.play("death")

func _set_mana(value):
	manaBar.value -= value

func _melee_attack():
	combatShouts.text = ""
	if meleeArea.has_overlapping_bodies():
		var entities = meleeArea.get_overlapping_bodies()
		for i in entities:
			if i.is_in_group("AllyToken"):
				var damage = randi_range(damageMinimum,damageMaximum)
				i._take_damage(damage)
				get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(tokenName+" strikes "+i.tokenName+" for "+str(damage)+" damage")
				get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
				break
		animatedSprite.play("attack_melee")
		actionTimer.start(randi_range(2,4))
	else:
		_choose_action()

func _shoot_projectile():
	animatedSprite.play("attack_ranged")
	var target = get_tree().get_nodes_in_group("AllyToken")
	var shootTarget = target.pick_random()
	var newArrow = rangedProjectile.instantiate()
	newArrow.dir = global_position.direction_to(shootTarget.global_position)
	newArrow.pos = marker.global_position
	add_child(newArrow)
	actionTimer.start(randi_range(4,8))

func _ranged_attack():
	combatShouts.text = ""
	if canChase and hasMelee:
		var randomNumber =randi_range(1,100)
		if randomNumber > 10:
			_chase_target()
		else:
			_shoot_projectile()

	else:
		_shoot_projectile()
	
	

func _magic_attack():
	if manaBar.value > manaCost:
		var target = get_tree().get_nodes_in_group("AllyToken")
		var shootTarget = target.pick_random()
		var newMagic = magicProjectile.instantiate()
		newMagic.dir = global_position.direction_to(shootTarget.global_position)
		newMagic.pos = marker.global_position
		add_child(newMagic)
		_set_mana(manaCost)
		actionTimer.start(randi_range(2,4))
	else:
		_choose_action()
		
func _chase_target():
	if canChase:
		combatShouts.text = ""
		if get_tree().get_node_count_in_group("AllyToken") == 0:
			var checker = get_tree().get_first_node_in_group("BattleMap")
			checker._check_win()
			return
		else:
			var availableTargets = get_tree().get_nodes_in_group("AllyToken")
			targetToChase = availableTargets.pick_random()
		if navigationAgent.is_navigation_finished() and targetToChase.global_position == navigationAgent.target_position:
			return
		animatedSprite.play("move")
		navigationAgent.target_position = Vector2(targetToChase.global_position.x + randi_range(-10,10), targetToChase.global_position.y + randi_range(-10,10))
		set_physics_process(true)
		actionTimer.start(randi_range(1,2))
	else:
		_choose_action()

func _attack():
	var attackChoice = attackOptions.pick_random()
	call(attackChoice)

func _choose_action():
	animatedSprite.play("idle")
	set_physics_process(false)
	if meleeArea.has_overlapping_bodies():
		var validMeleeTargets = meleeArea.get_overlapping_bodies()
		for i in validMeleeTargets:
			if i.is_in_group("AllyToken"):
				_attack()
	elif hasMagic == true or hasRanged == true:
		_attack()
	else:
		_chase_target()

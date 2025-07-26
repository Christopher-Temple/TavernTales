extends CharacterBody2D
class_name BaseAllyToken

@export var damageMinimum : int
@export var damageMaximum : int
@export var tokenHealth : int
@export var tokenMana: int
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

@export var hasMelee : bool
@export var hasRanged : bool
@export var hasMagic : bool
@export var canChase : bool

var currentAttackTarget

var attackOptions = []

func _ready() -> void:
	_set_stats()
	
func _set_stats():
	tokenHealth = tokenConstitution * 5
	healthBar.max_value = tokenHealth
	healthBar.value = tokenHealth
	nameTag.text = specialName+tokenName
	tokenMana = tokenWisdom * 5
	manaBar.max_value = tokenMana
	manaBar.value = tokenMana
	if hasMagic:
		attackOptions.append("_magic_attack")
	if hasMelee:
		attackOptions.append("_melee_attack")
	if hasRanged:
		attackOptions.append("_ranged_attack")
	print(attackOptions)
	

func _physics_process(_delta):
	velocity = global_position.direction_to(navigationAgent.get_next_path_position()) * tokenSpeed
	if velocity.x > 0:
		animatedSprite.flip_h = true
	elif velocity.x < 0:
		animatedSprite.flip_h = false
	move_and_slide()
	
func _take_damage(damageDealt):
	_set_health(damageDealt)
	animationPlayer.play("damaged")
	
func _set_health(value):
	hurtNoise.play()
	healthBar.value -= value
	if healthBar.value == 0:
		queue_free()
	
func _set_mana(value):
	manaBar.value = value

func _melee_attack():
	combatShouts.text = ""
	
	if meleeArea.has_overlapping_bodies():
		var entities = meleeArea.get_overlapping_bodies()
		for i in entities:
			if i.is_in_group("EnemyToken"):
				animatedSprite.play("attack")
				var damage = randi_range(damageMinimum,damageMaximum)
				i._take_damage(damage)
				get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(tokenName+" strikes "+i.tokenName+" for "+str(damage)+" damage")
				get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
				await get_tree().create_timer(0.10).timeout
				break
		actionTimer.start(randi_range(2,4))
	else:
		_choose_action()

func _ranged_attack():
	combatShouts.text = ""
	animatedSprite.play("rangedAttack")
	var target = get_tree().get_nodes_in_group("EnemyToken")
	var shootTarget = target.pick_random()
	var newArrow = rangedProjectile.instantiate()
	newArrow.dir = global_position.direction_to(shootTarget.global_position)
	newArrow.pos = marker.global_position
	add_child(newArrow)
	actionTimer.start(randi_range(2,3))
	
func _magic_attack():
	if manaBar.value > manaCost:
		animatedSprite.play("cast")
		var target = get_tree().get_nodes_in_group("EnemyToken")
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
		if get_tree().get_node_count_in_group("EnemyToken") == 0:
			var checker = get_tree().get_first_node_in_group("BattleMap")
			checker._check_win()
			return
		else:
			var availableTargets = get_tree().get_nodes_in_group("EnemyToken")
			targetToChase = availableTargets.pick_random()
		if navigationAgent.is_navigation_finished() and targetToChase.global_position == navigationAgent.target_position:
			return
		navigationAgent.target_position = targetToChase.global_position
		animatedSprite.play("move")
		set_physics_process(true)
		actionTimer.start(randi_range(1,2))
	else:
		_choose_action()
		
func _attack():
	print(attackOptions)
	var attackChoice = attackOptions.pick_random()
	print(attackChoice)
	call(attackChoice)
	
func _choose_action():
	set_physics_process(false)
	if meleeArea.has_overlapping_bodies():
		var validMeleeTargets = meleeArea.get_overlapping_bodies()
		for i in validMeleeTargets:
			if i.is_in_group("EnemyToken"):
				_attack()
	elif hasMagic == true or hasRanged == true:
		_attack()
	else:
		_chase_target()

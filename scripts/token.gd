extends CharacterBody2D

@onready var animatedSprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var nameTag: RichTextLabel = $RichTextLabel

@onready var animation_player = $AnimationPlayer
@onready var navigation_agent = $NavigationAgent2D
@export var targetToChase = CharacterBody2D
@onready var combat_shouts = $combatShouts
@onready var armor = GlobalVariables.gEquippedArmor
@onready var weapon = GlobalVariables.gEquippedWeapon
@onready var weaponType = TavernEquipment.Weapons[weapon]["TYPE"]
@onready var weaponDamage = TavernEquipment.Weapons[weapon]["DMG"]
@onready var healthBonus = TavernEquipment.Armors[armor]["HP"] * 5
@onready var strBonus = TavernEquipment.Armors[armor]["STR"]
@onready var conBonus = TavernEquipment.Armors[armor]["CON"]
@onready var wisBonus = TavernEquipment.Armors[armor]["WIS"]
@onready var chaBonus = TavernEquipment.Armors[armor]["CHA"]
@onready var dexBonus = TavernEquipment.Armors[armor]["DEX"]
@onready var healthStat = (GlobalVariables.gCharacterCon + conBonus) * 10
@onready var manaBonus = TavernEquipment.Weapons[weapon]["MANA"] * 5
@onready var manaStat = (GlobalVariables.gCharacterWis + wisBonus) * 10
@onready var health_bar: ProgressBar = $HealthBar
@onready var mana_bar: ProgressBar = $ManaBar
@onready var attackOptions = []
@onready var combat_animations: AnimatedSprite2D = $CombatAnimations

var playerTraits = GlobalVariables.gCharacterTraits
var playerName = GlobalVariables.gCharacterName
var playerRace = GlobalVariables.gCharacterRace
var playerClass = GlobalVariables.gCharacterClass
var rageBonus = 0
var tokenSpeed = 180
var tokenName = GlobalVariables.gCharacterName

func _ready():
	health_bar.max_value = healthStat+healthBonus
	health_bar.value = health_bar.max_value
	mana_bar.max_value = manaStat + manaBonus
	mana_bar.value = mana_bar.max_value
	if weaponType == "Ranged":
		attackOptions.append("_ranged_attack")
	if weaponType == "Melee":
		attackOptions.append("_melee_attack")
	if GlobalVariables.gCharacterHasMagic == true:
		attackOptions.append("_magic_attack")
	if playerClass == "Paladin":
		attackOptions.append("_divine_strike")
	if playerRace == "Dragonborn":
		attackOptions.append("_fire_breath")
	if playerRace == "Yuan-ti":
		attackOptions.append("_poison_spray")
	animatedSprite.play(GlobalVariables.gCharacterRace+"_idle")
	nameTag.text = "[center]"+tokenName
	
	
func _physics_process(_delta):
	velocity = global_position.direction_to(navigation_agent.get_next_path_position()) * tokenSpeed
	if velocity.x > 0:
		animatedSprite.flip_h = true
		combat_animations.flip_h = true
		combat_animations.position = $rightside.position
	elif velocity.x < 0:
		animatedSprite.flip_h = false
		combat_animations.flip_h = false
		combat_animations.position = $leftside.position
	move_and_slide()

func _set_health(value):
	$ouch.play()
	if playerTraits.has("Natural Armor"):
		value = value - 1
	health_bar.value -= value
	if health_bar.value < health_bar.max_value / 2:
		rageBonus = 5
		if playerTraits.has("Heal Wound") and mana_bar.value > 3:
			animatedSprite.play(playerRace+"_magic")
			health_bar.value += GlobalVariables.gCharacterCon + GlobalVariables.gCharacterWis
			mana_bar.value -= 3
	if health_bar.value < health_bar.max_value / 10 and GlobalVariables.gPlayerPotion.has("Healing Potion"):
		GlobalVariables.gPlayerPotion.erase("Healing Potion")
		health_bar.value += GlobalVariables.gCharacterCon * 2
	if health_bar.value == 0:
		death()

func death():
	$Timer.stop()
	set_physics_process(false)
	animatedSprite.play(playerRace+"_death")
	nameTag.hide()
	mana_bar.hide()
	health_bar.hide()
	$Area2D.hide()
	$CollisionShape2D.disabled = true
	await get_tree().create_timer(2).timeout
	animation_player.play("death")
	
func _set_mana(value):
	$ManaBar.value = value
	
func _attack():
	var pickAttack = attackOptions.pick_random()
	call(pickAttack)
	
func _melee_attack():
	combat_shouts.text = ""
	var entities = $Area2D.get_overlapping_bodies()
	var attackPower = weaponDamage + (GlobalVariables.gCharacterStr / 2) + (randi_range(0,3))
	combat_animations.play(GlobalVariables.gEquippedWeapon)
	for i in entities:
		if i.is_in_group("EnemyToken"):
			i._take_damage(attackPower + rageBonus)
			get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(GlobalVariables.gCharacterName+" hits "+i.tokenName+" for "+str(attackPower) +" damage")
			get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
			if playerClass == "Monk":
				_flurry_of_blows()
			else:
				pass
		await get_tree().create_timer(0.10).timeout
		break
	$Timer.start(randi_range(2,4))
	
func _battle_cry():
	var combatShout = randi_range(1,3)
	if combatShout == 1:
		combat_shouts.text = "You cannot run from me!"
	elif combatShout == 2:
		combat_shouts.text = "Stand and fight you coward."
	elif combatShout == 3:
		combat_shouts.text = "Feel my wrath!"
	else:
		pass

func _move_to_target():
	_battle_cry()
	if get_tree().get_node_count_in_group("EnemyToken") == 0:
		var checker = get_tree().get_first_node_in_group("BattleMap")
		checker._check_win()
		return
	else:
		var availableTargets = get_tree().get_nodes_in_group("EnemyToken")
		targetToChase = availableTargets.pick_random()
	if navigation_agent.is_navigation_finished() and targetToChase.global_position == navigation_agent.target_position:
		return
	if GlobalVariables.gCharacterRace == "Shadar-kai":
		$teleportAnimation.play("teleport")
	else:
		navigation_agent.target_position = targetToChase.global_position	
		set_physics_process(true)
		animatedSprite.play(GlobalVariables.gCharacterRace+"_move")
		$Timer.start(randi_range(1,3))

func _ranged_attack():
	_choose_action()

func _cast_spell():
	_choose_action()
	
func _choose_action():
	set_physics_process(false)
	if $Area2D.has_overlapping_bodies():
		var validMeleeTargets = $Area2D.get_overlapping_bodies()
		for i in validMeleeTargets:
			if i.is_in_group("EnemyToken"):
				_attack()
	else:
		if weaponType == "Ranged" or GlobalVariables.gCharacterHasMagic == true:
			_attack()
		else:
			_move_to_target()

		
func _take_damage(damageDealt):
	_set_health(damageDealt)
	animation_player.play("damaged")


func _on_timer_timeout():
	_choose_action()


func _on_update_target_timeout() -> void:
	if get_tree().get_node_count_in_group("EnemyToken") == 0:
		pass
	else:
		navigation_agent.target_position = targetToChase.global_position

func attack_animation(attack):
	combat_animations.play(attack)
	
# Class , Race , and Background functions

func _divine_strike():
	combat_shouts.text = "Face divine justice!"
	var entities = $Area2D.get_overlapping_bodies()
	var attackPower = weaponDamage + (GlobalVariables.gCharacterStr / 2) + (randi_range(0,3))
	combat_animations.play(GlobalVariables.gEquippedWeapon)
	for i in entities:
		if i.is_in_group("EnemyToken"):
			i._take_damage(attackPower + 10)
			get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(GlobalVariables.gCharacterName+" divine strikes "+i.tokenName+" for "+str(attackPower) +" damage")
			get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
			await get_tree().create_timer(0.10).timeout
			break
			$Timer.start(randi_range(2,4))
			
func _fire_breath():
	combat_shouts.text = "[wave][color=red]BUUUUURN!!"
	var entities = $Area2D.get_overlapping_bodies()
	var breathPower = (GlobalVariables.gCharacterCon / 2) + (randi_range(0,5))
	animatedSprite.play(GlobalVariables.gCharacterRace+"_magic")
	combat_animations.play("Flame Breath")
	for i in entities:
		if i.is_in_group("EnemyToken"):
			i._take_damage(breathPower)
			get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(GlobalVariables.gCharacterName+" hit "+i.tokenName+" with Flame Breath for "+str(breathPower) +" damage")
			get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
	$Timer.start(randi_range(2,4))
	
func _poison_spray():
	combat_shouts.text = ""
	var entities = $Area2D.get_overlapping_bodies()
	var breathPower = GlobalVariables.gCharacterWis + (randi_range(0,5))
	animatedSprite.play(GlobalVariables.gCharacterRace+"_magic")
	combat_animations.play("Poison Spray")
	for i in entities:
		if i.is_in_group("EnemyToken"):
			i._take_damage(breathPower)
			get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(GlobalVariables.gCharacterName+" hit "+i.tokenName+" with Acid Spray for "+str(breathPower) +" damage")
			get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
	$Timer.start(randi_range(2,4))

func _flurry_of_blows():
	var entities = $Area2D.get_overlapping_bodies()
	var attackPower = GlobalVariables.gCharacterStr / 2 + (randi_range(0,3))
	var targets = []
	for i in entities:
		if i.is_in_group("EnemyToken"):
			i._take_damage(attackPower + rageBonus)
			get_tree().get_first_node_in_group("BattleMap").combat_log.add_text(GlobalVariables.gCharacterName+" kicks "+i.tokenName+" for "+str(attackPower) +" damage")
			get_tree().get_first_node_in_group("BattleMap").combat_log.newline()
			break

func _teleport():
	var potentialTargets = get_tree().get_nodes_in_group("EnemyToken")
	var teleportTarget = potentialTargets.pick_random()
	$".".global_position = Vector2(teleportTarget.global_position.x - 5, teleportTarget.global_position.y - 5)

	
func _teleport_start():
	$teleport.play("teleport_start")
func _teleport_stop():
	$teleport.play("teleport_stop")

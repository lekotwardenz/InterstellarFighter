class_name Enemy

extends Entity

@export var maxCooldown : float
@export var minCooldown : float
@export var lazerTypeScene : PackedScene

@export var score_value : int

signal enemy_fire(fire : Lazer, position : Vector2)
signal gain_score(value : int)
	
func generate_random_cooldown() -> float:
	var randomCooldown = randf_range(minCooldown, maxCooldown)
	
	return randomCooldown
	
func construct_lazer() -> Lazer:
	var lazer : Lazer = lazerTypeScene.instantiate()
	lazer.damage = damage
	lazer.speed = lazer_speed
	lazer.direction = 1
	
	return lazer
	
func initiate_fire(delta : float) -> void:
	if (cooldownTimer < cooldown):
		cooldownTimer += delta	
		
	if (cooldownTimer >= cooldown):
		enemy_fire.emit(construct_lazer(), global_position)
		generate_random_cooldown()
		cooldownTimer = 0
		
func die() -> void:
	super.die()
	
	gain_score.emit(score_value)		
		
func construct_state_machine() -> void:
	if (stateMachine):
		
		stateMachine.initial_state = defaultState
		
		stateMachine.add_transition(stateMachine.ANYSTATE, defaultState, "to_default")
		stateMachine.add_transition(defaultState, hurtState, "to_hurt")
		
		super.construct_state_machine()

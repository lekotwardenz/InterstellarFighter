class_name Player

extends Entity

signal UpdateHealth(newHealth : float)
signal player_fire(position : Vector2, damage : float, lazerSpeed : float, direction : int)

func apply_input() -> void:
	var direction = Input.get_vector("left", "right", "up", "down")
	
	if (Input.is_action_just_pressed("fire")):
		if (cooldownTimer >= cooldown):
			player_fire.emit(global_position, damage, lazer_speed, -1)
			cooldownTimer = 0
	
	velocity = direction * speed
	
func take_damage(damage : int) -> void:
	super.take_damage(damage)
	
	UpdateHealth.emit(health)
	

func construct_state_machine() -> void:
	if (stateMachine):
		stateMachine.initial_state = defaultState
		
		stateMachine.add_transition(stateMachine.ANYSTATE, defaultState, "to_default")
		stateMachine.add_transition(defaultState, hurtState, "to_hurt")
		
		super.construct_state_machine()
	
	

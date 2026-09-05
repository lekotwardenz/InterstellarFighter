extends LimboState

var entity : EnemyBomber

const DISTANCE_FROM_PLAYER := 50.0

func _setup() -> void:
	entity = agent as EnemyBomber
	
func _enter() -> void:
	pass
	
func _update(delta: float) -> void:
	entity.face_player(delta)
	
	if (entity.trackerTimer < entity.TRACKER_COOLDOWN):
		entity.trackerTimer += delta
	elif (entity.trackerTimer >= entity.TRACKER_COOLDOWN):
		entity.velocity = entity.approach_player()
		entity.trackerTimer = 0.0
	
	if (entity.player):
		var distance = entity.player.global_position - entity.global_position
	
		if (distance.length() <= DISTANCE_FROM_PLAYER):
			entity.stateMachine.dispatch("to_explode")
	

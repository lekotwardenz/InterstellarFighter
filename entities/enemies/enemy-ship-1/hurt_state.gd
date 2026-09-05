extends LimboState

const IFRAMETIME : float = 0.3

var entity : Entity
var iFrameTimer : float = 0.0

func _setup() -> void:
	entity = agent as EnemyShip1

func _enter() -> void:
	entity.hitbox.set_deferred("monitorable", false)
	
func _update(delta: float) -> void:
	if (entity):
		if (entity.shake_timer < entity.SHAKE_TIME):
			entity.trigger_shake()
			entity.shake_timer += delta
			
		if (entity.shake_timer >= entity.SHAKE_TIME):
			entity.sprite.position = entity.spritePosition
		
		if (iFrameTimer < IFRAMETIME):
			iFrameTimer += delta
			
		if (iFrameTimer >= IFRAMETIME):
			entity.shake_timer = 0.0
			iFrameTimer = 0.0
			entity.hitbox.set_deferred("monitorable", true)
			dispatch("to_default")	
		
	

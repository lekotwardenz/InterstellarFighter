extends LimboState

var entity : EnemyBomber

var blood_explosion_scene : PackedScene = load("res://misc/effects/blood_explosion/blood_explosion.tscn")

var sparksEffect : GPUParticles2D
var sparksCooldownTimer : float = 0.0


func _setup() -> void:
	entity = agent as EnemyBomber
	
func _enter() -> void:
	entity.hitbox.set_deferred("monitorable", false)
	trigger_explosion(1)
	
func _update(delta: float) -> void:
	if (entity.velocity != Vector2.ZERO):
		entity.velocity = lerp(entity.velocity, Vector2.ZERO, 5.0 * delta)

func trigger_explosion(duration: float) -> void:
	var material = entity.sprite.material as ShaderMaterial
	if not material:
		return
		
	var tween = create_tween()
	tween.tween_method(
		func(val: float): material.set_shader_parameter("white_progress", val), 
		0.0, 
		1.0, 
		duration
	)
	
	await tween.finished
	
	entity.sprite.visible = false
	if (entity.trail):
		entity.trail.visible = false
	entity.gain_score.emit(entity.score_value)
	
	create_explosion()
	
func create_explosion() -> void:
	var blood_explosion : GPUParticles2D = blood_explosion_scene.instantiate()
	var explosion_aoe : AOE = entity.lazerTypeScene.instantiate()
	
	explosion_aoe.damage = 20
	
	blood_explosion.finished.connect(finish_explosion)
	
	entity.add_child(blood_explosion)
	
	blood_explosion.global_position = entity.global_position
	entity.execute_death.emit(entity.global_position, create_explosion_death())
	entity.enemy_fire.emit(explosion_aoe, entity.global_position)
	blood_explosion.restart()
	
func finish_explosion() -> void:
	entity.queue_free()	
	
func create_explosion_death() -> GPUParticles2D:
	return entity.explosionOnDeathScene.instantiate()

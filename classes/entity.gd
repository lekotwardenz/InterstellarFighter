class_name Entity

extends CharacterBody2D

@export var sprite : AnimatedSprite2D
@export var explosionOnDeathScene : PackedScene
@export var hitExplosionScene : PackedScene
@export var hitFlash : AnimationPlayer
@export var hitbox : Area2D
@export var trail : GPUParticles2D

@export var health : float
@export var damage : float
@export var lazer_speed : float
@export var speed : float
@export var cooldown : float

@export var stateMachine : LimboHSM
@export var defaultState : LimboState
@export var hurtState : LimboState


const SHAKE_INTESITY : float = 2
const SHAKE_TIME : float = 0.1

var shake_timer : float = 0.0
var spritePosition : Vector2 

var cooldownTimer : float = 0.0

signal execute_death(position : Vector2, explosion : GPUParticles2D)
signal execute_hit(postion : Vector2, hitEffect : GPUParticles2D)

func die() -> void:
	if (explosionOnDeathScene):
		var explosionOnDeath : GPUParticles2D = explosionOnDeathScene.instantiate()
	
		explosionOnDeath.restart()
		execute_death.emit(global_position, explosionOnDeath)
	
	queue_free()

func take_damage(damage : int) -> void:
	var hitExplosion : GPUParticles2D = hitExplosionScene.instantiate()
	
	if (hitFlash):
		hitFlash.play("hit_flash")
	else:
		if (sprite.material):
			flash_on_hit()
		
	if (stateMachine):
		stateMachine.dispatch("to_hurt")
		
	hitExplosion.restart()
	execute_hit.emit(global_position, hitExplosion)	
		
	var newHealth = health - damage
	
	if (newHealth <= 0):
		die()
		newHealth = 0
		
	health = newHealth	
	
func trigger_shake() -> void:
	sprite.position = spritePosition + Vector2(
			randf_range(-SHAKE_INTESITY, SHAKE_INTESITY),
			randf_range(-SHAKE_INTESITY, SHAKE_INTESITY)
		)
		
func construct_state_machine() -> void:
	if (stateMachine):
		stateMachine.initialize(self)
		stateMachine.set_active(true)
		
func flash_on_hit() -> void:
	var material = sprite.material as ShaderMaterial
	if not material:
		return
		
	# Kill any existing tweens on this node so rapid-fire hits don't glitch the animation
	var tween = create_tween()
	
	# 1. Instantly spike to pure white over 0.05 seconds
	tween.tween_method(
		func(val: float): material.set_shader_parameter("white_progress", val), 
		0.0, 
		1.0, 
		0.05
	)
	
	# 2. Fade back down to normal colors over 0.1 seconds
	tween.tween_method(
		func(val: float): material.set_shader_parameter("white_progress", val), 
		1.0, 
		0.0, 
		0.1
	)		

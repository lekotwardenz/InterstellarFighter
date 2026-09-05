extends Player

func _ready() -> void:
	explosionOnDeathScene = load("res://misc/effects/small_explosion/small_explosion.tscn")
	hitExplosionScene = load("res://misc/effects/small_hit/small_hit.tscn")
	spritePosition = sprite.position
	
	speed = 300.0
	damage = 10.0
	health = 100.0
	lazer_speed = 400.0
	cooldown = 0.2
	
	construct_state_machine()
	
func _physics_process(delta: float) -> void:
	if (cooldownTimer < cooldown):
		cooldownTimer += delta 
	apply_input()
	
	move_and_slide()

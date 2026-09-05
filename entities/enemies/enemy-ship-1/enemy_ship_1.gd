class_name EnemyShip1

extends Enemy

func _ready() -> void:
	lazerTypeScene = load("res://misc/enemy-lazer/lazer_red.tscn")
	explosionOnDeathScene = load("res://misc/effects/small_explosion/small_explosion.tscn")
	hitExplosionScene = load("res://misc/effects/small_hit/small_hit.tscn")
	
	health = 30
	damage = 5
	minCooldown = 2.0
	maxCooldown = 4.0
	lazer_speed = 200
	
	cooldown = generate_random_cooldown()
	
	construct_state_machine()

func _process(delta: float) -> void:
	initiate_fire(delta)

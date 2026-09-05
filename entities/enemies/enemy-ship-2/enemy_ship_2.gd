class_name EnemyShip2

extends Enemy

@export var marker : Marker2D

@export var canFire : bool = true

func _ready() -> void:
	minCooldown = 3.0
	maxCooldown = 5.0
	
	health = 40
	damage = 2
	lazer_speed = 0
	
	cooldown = generate_random_cooldown()
	
	lazerTypeScene = load("res://misc/lazer-beam/lazer_beam.tscn")
	explosionOnDeathScene = load("res://misc/effects/small_explosion/small_explosion.tscn")
	hitExplosionScene = load("res://misc/effects/small_hit/small_hit.tscn")
	
	construct_state_machine()

func _physics_process(delta: float) -> void:
	if (canFire):
		initiate_beam(delta)
	
func initiate_beam(delta : float) -> void:
	
	if (cooldownTimer < cooldown):
		cooldownTimer += delta	
		
	if (cooldownTimer >= cooldown):
		fire_beam()
		cooldown = generate_random_cooldown()
		canFire = false
		cooldownTimer = 0
	
func fire_beam() -> void:
	var beam : Beam = construct_lazer() 
	
	beam.name = "Enemy_Beam"
	beam.position = marker.position
	beam.entity_owner = self
	
	add_child(beam)

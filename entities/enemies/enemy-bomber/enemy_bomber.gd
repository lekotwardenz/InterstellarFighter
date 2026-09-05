class_name EnemyBomber

extends TrackerEnemy

@export var explodeState : LimboState

func _ready() -> void:
	health = 10
	speed = 80
	rotation_speed = 5
	
	velocity = approach_player()
	lazerTypeScene = load("res://misc/aoe_explosion/explosion_aoe.tscn")
	explosionOnDeathScene = load("res://misc/effects/small_explosion/small_explosion.tscn")
	hitExplosionScene = load("res://misc/effects/small_hit/small_hit.tscn")
	
	construct_state_machine()

func _physics_process(delta: float) -> void:
		
	move_and_slide()
	
func construct_state_machine() -> void:
	super.construct_state_machine()
	
	stateMachine.add_transition(stateMachine.ANYSTATE, explodeState, "to_explode")
	
func die() -> void:
	pass

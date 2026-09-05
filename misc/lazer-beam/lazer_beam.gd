class_name Beam

extends Lazer
@export var collision_shape : CollisionShape2D
@export var area_shape : Area2D
@export var beam : Line2D
@export var beam2 : Line2D
@export var hsm : LimboHSM
@export var firingState : LimboState
@export var fireState : LimboState
@export var endState : LimboState
@export var firingParticles : GPUParticles2D
@export var to_delete_timer : Timer

@export var entity_owner : Enemy

var collected_areas : Array
var damage_cooldown_timer : float = 0.0

const DAMAGE_COOLDOWN : float = 0.1
const START_POINT := 0
const END_POINT := 1

const MAX_LENGTH := 800.0

func _ready() -> void:
	beam.set_point_position(END_POINT, Vector2.ZERO)
	beam.set_point_position(END_POINT, Vector2.ZERO)
	collision_shape.shape.size.y = 0
	
	set_up_statemachine()

func _process(delta: float) -> void:
	pass
	
func set_up_statemachine() -> void:
	if (hsm):
		hsm.initial_state = fireState
		
		hsm.add_transition(fireState, firingState, "to_firing")
		hsm.add_transition(firingState, endState, "to_end")
		
		hsm.initialize(self)
		hsm.set_active(true)

func damage_manager(delta : float) -> void:
	if (damage_cooldown_timer < DAMAGE_COOLDOWN):
		damage_cooldown_timer += delta
		
	if (damage_cooldown_timer >= DAMAGE_COOLDOWN):
		damage_cooldown_timer = 0.0
		if (collected_areas.size() > 0):
			for body in collected_areas:
				detect_damage(body)
				
		
func _on_area_entered(area: Area2D) -> void:
	damage_cooldown_timer = 0.0
	collected_areas.append(area)

func _on_area_exited(area: Area2D) -> void:
	collected_areas.erase(area)

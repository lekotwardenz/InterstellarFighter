extends LimboState

var firing_timer : float = 0.0

const FIRING_TIME : float = 1.5

var entity : Beam

func _setup() -> void:
	entity = agent as Beam
	
func _update(delta: float) -> void:
	if (firing_timer < FIRING_TIME):
		firing_timer += delta
		
	entity.damage_manager(delta)	
		
	if (firing_timer >= FIRING_TIME):
		dispatch("to_end")	
		

extends LimboState

var entity : Beam
var tween : Tween

var stopping_beam : bool = false

func _setup() -> void:
	entity = agent as Beam

func _enter() -> void:
	var tween = create_tween()
	entity.firingParticles.emitting = false
	
	tween.tween_method(
		self.update_beam_closing,
		0.0, 
		entity.MAX_LENGTH, 
		0.2
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
func _update(delta: float) -> void:
	var beam_length = entity.beam.get_point_position(entity.START_POINT)
	
	entity.damage_manager(delta)	
	
	if (not stopping_beam):
		if (beam_length.y >= entity.MAX_LENGTH):
			if (entity.entity_owner):
				entity.entity_owner.canFire = true
			
			stopping_beam = true
			disable_beam()
			entity.to_delete_timer.start(1)
	
func update_beam_closing(top_y: float) -> void:
	entity.beam.set_point_position(entity.START_POINT, Vector2(0, top_y))
	entity.beam2.set_point_position(entity.START_POINT, Vector2(0,top_y))
	
	var remaining_length = entity.MAX_LENGTH - top_y
	
	var rect_shape = entity.collision_shape.shape as RectangleShape2D
	if rect_shape:
		rect_shape.size.y = remaining_length
		
		entity.collision_shape.position.y = top_y + (remaining_length / 2.0)
		
func disable_beam() -> void:
	entity.area_shape.monitoring = false
	entity.beam.visible = false

func _on_to_delete_timer_timeout() -> void:
	entity.queue_free()

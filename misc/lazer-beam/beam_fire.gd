extends LimboState

var entity : Beam

var tween : Tween

func _setup() -> void:
	entity = agent as Beam

func _enter() -> void:
	tween = create_tween()
	
	tween.tween_method(
		self.update_beam_length,
		Vector2.ZERO,
		Vector2(0,entity.MAX_LENGTH),
		0.1
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
func _update(delta: float) -> void:
	var beam_length = entity.beam.get_point_position(entity.END_POINT)
	
	entity.damage_manager(delta)		
	
	if (beam_length.y >= entity.MAX_LENGTH):
		dispatch("to_firing")
	
func update_beam_length(current_pos : Vector2) -> void:
	entity.beam.set_point_position(entity.END_POINT, current_pos)
	entity.beam2.set_point_position(entity.END_POINT, current_pos)
	
	var beam_length = abs(current_pos.y)
	
	var rect_shape = entity.collision_shape.shape as RectangleShape2D
	if rect_shape:
		rect_shape.size.y = beam_length
		
		entity.collision_shape.position.y = beam_length / 2.0

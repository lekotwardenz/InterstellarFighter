extends Lazer

func _ready() -> void:
	pass 

func _physics_process(delta: float) -> void:
	delete_lazer()
	
	lazer_travel(delta)

func _on_area_entered(area: Area2D) -> void:
	detect_damage(area)
	
	queue_free()

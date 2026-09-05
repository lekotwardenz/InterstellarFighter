class_name  AOE

extends Lazer

func _on_sprite_animation_finished() -> void:
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	detect_damage(area)

class_name Lazer

extends Area2D

@export var damage : float
@export var sprite : Sprite2D
@export var direction : int
@export var speed : float

func lazer_travel(delta : float) -> void:
	position.y += (direction * speed) * delta
	
func delete_lazer() -> void:
	if (position.y < 0 or position.y > ScreenDimension.windowY or position.x < 0 or position.x > ScreenDimension.windowX):
		queue_free()
		
func detect_damage(area : Area2D):
	var entity : Entity = area.get_parent()
	
	if (entity.has_method("take_damage")):
		entity.take_damage(damage)			

class_name TrackerEnemy

extends Enemy

@export var player : Player
@export var rotation_speed: float

@export var navAgent : NavigationAgent2D

var trackerTimer : float = 0.0

const TRACKER_COOLDOWN : float = 0.3

func approach_player() -> Vector2:
	if (player):
		set_meta("is_in_formation", false)
		navAgent.target_position = player.global_position
		
	var nextPath = navAgent.get_next_path_position()
	
	var desiredPath : Vector2 = (nextPath - global_position).normalized() * speed
	
	return desiredPath

func face_player(delta: float) -> void:
	if not player:
		return
		
	var target_angle = global_position.angle_to_point(player.global_position) - (PI / 2)
	
	sprite.rotation = lerp_angle(sprite.rotation, target_angle, rotation_speed * delta)

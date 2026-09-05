class_name HealthBar

extends Control

@export var greenHealth : TextureProgressBar
@export var redHealth : TextureProgressBar
@export var blueBar : TextureProgressBar
@export var player : Player
@export var timer : Timer
		
func ConnectHealthPlayer(player : Player) -> void:
	self.player = player	
		
	greenHealth.max_value = player.health
	greenHealth.value = greenHealth.max_value
		
	redHealth.max_value = player.health
	redHealth.value = redHealth.max_value
		
	player.UpdateHealth.connect(UpdateHealth)
		
func UpdateHealth(newHealth : float) -> void:
	var oldHealth : float = greenHealth.value
	greenHealth.value = newHealth
	
	if (oldHealth > newHealth):
		timer.start(0.5)
	

func _on_timer_timeout() -> void:
	redHealth.value = greenHealth.value

class_name World
extends Node2D

@export var player : Player
@export var healthBar : HealthBar
@export var score_display : RichTextLabel

var playerLazerContainer : Node2D
var enemyLazerContainer : Node2D
var effectsContainer : Node2D

var player_lazer_scene : PackedScene = load("res://misc/player-lazer/player_lazer.tscn")
var player_scene : PackedScene = load("res://entities/player/player-scene.tscn")

# Manager instances
var wave_manager : Wave_Manager
var entity_spawner : Entity_Spawner
var score_manager : ScoreManager

func _ready() -> void:
	set_up_world()

func set_up_world() -> void:
	if not playerLazerContainer:
		playerLazerContainer = Node2D.new()
		playerLazerContainer.name = "playerLazerContainer"
		
	if not enemyLazerContainer:
		enemyLazerContainer = Node2D.new()
		enemyLazerContainer.name = "enemyLazerContainer"
		
	if not effectsContainer:
		effectsContainer = Node2D.new()
		effectsContainer.name = "effectsContainer"
	
	add_child(enemyLazerContainer)
	add_child(effectsContainer)
	add_child(playerLazerContainer)
	
	if not player:
		player = player_scene.instantiate()
		player.name = "Player"
		player.player_fire.connect(on_player_fire)
		player.execute_death.connect(on_death_explosion)
		player.execute_hit.connect(on_hit_explosion)
	
	add_child(player)
	
	healthBar.ConnectHealthPlayer(player)
	
	# Place the player at the bottom center (1080 / 2, 720 - offset)
	player.global_position = Vector2(540.0, 660.0) 
	
	# Initialize Managers and start the wave
	wave_manager = Wave_Manager.new()
	add_child(wave_manager)
	
	entity_spawner = Entity_Spawner.new()
	add_child(entity_spawner)
	
	score_manager = ScoreManager.new()
	add_child(score_manager)
	
	entity_spawner.wave_cleared.connect(trigger_wave)
	
	trigger_wave()

func trigger_wave() -> void:
	var formation = wave_manager.get_wave_formation(1)
	entity_spawner.spawn_wave(formation, self)

# --- Signals ---

func on_player_fire(position : Vector2, damage : float, lazerSpeed : float, direction : int) -> void:
	var playerLazer : Lazer = player_lazer_scene.instantiate()
	playerLazer.speed = lazerSpeed
	playerLazer.damage = damage
	playerLazer.direction = direction
	playerLazer.global_position = position
	playerLazer.name = "playerLazer"
	
	playerLazerContainer.add_child(playerLazer)
		
func on_enemy_fire(lazer : Lazer, position : Vector2) -> void:
	if (lazer and position != Vector2.ZERO):
		lazer.global_position = position
		enemyLazerContainer.add_child(lazer)
	
func on_death_explosion(position : Vector2, explosion : GPUParticles2D) -> void:
	if (explosion and position != Vector2.ZERO):
		explosion.global_position = position
		effectsContainer.add_child(explosion)
	
func on_hit_explosion(position : Vector2, explosion : GPUParticles2D) -> void:
	if (explosion and position != Vector2.ZERO):
		explosion.global_position = position
		effectsContainer.add_child(explosion)
		
func on_gain_score(value : int) -> void:
	score_manager.updateScore(value)
	
	score_display.text = str(score_manager.getSore())

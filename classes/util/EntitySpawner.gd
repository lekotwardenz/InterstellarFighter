class_name Entity_Spawner
extends Node

# --- NEW SIGNAL ---
signal wave_cleared 

var scene_cache: Dictionary = {}
var all_rows: Dictionary = {}
var active_enemies: Array = []
var max_row_index: int = 0
var current_row_index: int = 0
var shift_distance: float = 48.0 
var kills_in_current_phase: int = 0
var required_kills_for_next: int = 0
var phase_timer: Timer

func _ready() -> void:
	phase_timer = Timer.new()
	phase_timer.one_shot = true
	phase_timer.timeout.connect(trigger_next_row)
	add_child(phase_timer)

func spawn_wave(formation_data: Array, world: Node) -> void:
	all_rows.clear()
	active_enemies.clear()
	kills_in_current_phase = 0
	max_row_index = 0

	for enemy_data in formation_data:
		var scene_path: String = enemy_data["enemy_path"]
		var target_pos: Vector2 = enemy_data["position"]
		var row_index: int = enemy_data["row"]

		max_row_index = max(max_row_index, row_index)

		if not all_rows.has(row_index):
			all_rows[row_index] = []

		var enemy_scene: PackedScene
		if scene_cache.has(scene_path):
			enemy_scene = scene_cache[scene_path]
		else:
			enemy_scene = load(scene_path)
			if enemy_scene:
				scene_cache[scene_path] = enemy_scene

		if enemy_scene:
			var enemy_instance : Enemy = enemy_scene.instantiate()
			world.add_child(enemy_instance)
			

			if "player" in world and "player" in enemy_instance:
				enemy_instance.player = world.player

			# World visual signals
			enemy_instance.enemy_fire.connect(world.on_enemy_fire)
			enemy_instance.execute_death.connect(world.on_death_explosion)
			enemy_instance.execute_hit.connect(world.on_hit_explosion)
			enemy_instance.gain_score.connect(world.on_gain_score)
			
			# Internal spawner math (uses tree_exited so Bombers blowing themselves up still count)
			enemy_instance.tree_exited.connect(_on_enemy_removed.bind(enemy_instance))

			if enemy_instance is Node2D:
				enemy_instance.set_meta("final_target_pos", target_pos)
				enemy_instance.set_meta("is_in_formation", true)

				enemy_instance.global_position = Vector2(target_pos.x, target_pos.y - 800)
				
				# Soft disable (allows animations to play)
				enemy_instance.set_physics_process(false)
				enemy_instance.set_process(false)
				if enemy_instance is CollisionObject2D:
					enemy_instance.set_meta("og_layer", enemy_instance.collision_layer)
					enemy_instance.set_meta("og_mask", enemy_instance.collision_mask)
					enemy_instance.collision_layer = 0
					enemy_instance.collision_mask = 0

				all_rows[row_index].append(enemy_instance)
		else:
			push_error("Entity_Spawner failed to load scene at path: " + scene_path)

	current_row_index = max_row_index
	trigger_next_row()

func trigger_next_row() -> void:
	if current_row_index < 0:
		phase_timer.stop()
		return 

	# 1. Shift all CURRENTLY active enemies down
	for enemy in active_enemies:
		if is_instance_valid(enemy):
			if enemy.has_meta("is_in_formation") and enemy.get_meta("is_in_formation") == true:
				var final_pos: Vector2 = enemy.get_meta("final_target_pos")
				var new_y = final_pos.y - (current_row_index * shift_distance)
				
				var tween = create_tween().bind_node(enemy)
				tween.tween_property(enemy, "global_position:y", new_y, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 2. Drop in the NEW row
	var new_row_enemies = all_rows.get(current_row_index, [])
	for enemy in new_row_enemies:
		if is_instance_valid(enemy):
			active_enemies.append(enemy)

			var final_pos: Vector2 = enemy.get_meta("final_target_pos")
			var drop_y = final_pos.y - (current_row_index * shift_distance)
			
			var tween = create_tween().bind_node(enemy)
			tween.tween_property(enemy, "global_position:y", drop_y, 0.8).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
			
			# Wake up the enemy
			tween.tween_callback(func(): 
				if is_instance_valid(enemy):
					enemy.set_physics_process(true)
					enemy.set_process(true)
					if enemy is CollisionObject2D:
						if enemy.has_meta("og_layer"): enemy.collision_layer = enemy.get_meta("og_layer")
						if enemy.has_meta("og_mask"): enemy.collision_mask = enemy.get_meta("og_mask")
			)

	kills_in_current_phase = 0
	required_kills_for_next = max(1, int(active_enemies.size() * 0.7))
	current_row_index -= 1
	
	# ---> SET TO 20 SECONDS AS REQUESTED
	phase_timer.start(20.0) 

# ---> NEW LOGIC: Check if the wave is fully cleared
func _on_enemy_removed(enemy: Node) -> void:
	if active_enemies.has(enemy):
		active_enemies.erase(enemy)
		kills_in_current_phase += 1

		# 1. Drop next row early if 70% threshold is met
		if current_row_index >= 0 and kills_in_current_phase >= required_kills_for_next:
			phase_timer.stop()
			trigger_next_row()
			
		# 2. Check if the ENTIRE WAVE is dead (no rows left to drop AND active_enemies is empty)
		elif current_row_index < 0 and active_enemies.is_empty():
			phase_timer.stop()
			print("Wave completely cleared! Requesting next wave...")
			call_deferred("emit_signal", "wave_cleared")

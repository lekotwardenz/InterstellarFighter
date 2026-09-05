class_name Wave_Manager
extends Node

const SCREEN_WIDTH: int = 1080
const SCREEN_HEIGHT: int = 720

const CELL_SIZE: int = 32
const SPACING: int = 16 
const TOTAL_CELL_STEP: int = CELL_SIZE + SPACING 

const ENEMIES = {
	1: "res://entities/enemies/enemy-ship-1/enemy_ship_1.tscn",
	2: "res://entities/enemies/enemy-bomber/enemy_bomber.tscn",
	3: "res://entities/enemies/enemy-ship-2/enemy_ship_2.tscn"
}

var available_formations: Array = [
	[	
		[3,2,3,0,0,0,0,0,0,0,0,0,3,2,3],
		[3,1,3,1,3,0,2,2,2,0,3,1,3,1,3],
		[3,1,1,1,3,2,2,3,2,2,3,1,1,1,3],
		[0,0,0,3,1,2,1,3,1,2,1,3,0,0,0]
	]
]

func _ready() -> void:
	randomize()

func get_wave_formation(_wave_index: int) -> Array:
	var formation_data: Array = []
	var selected_grid: Array = available_formations.pick_random() 

	var columns = selected_grid[0].size()
	var rows = selected_grid.size()
	var formation_width = columns * TOTAL_CELL_STEP
	var start_x = (SCREEN_WIDTH / 2.0) - (formation_width / 2.0)
	var start_y = 100.0 

	for row in range(rows):
		for col in range(columns):
			var enemy_id = selected_grid[row][col]

			if enemy_id > 0:
				var spawn_pos = Vector2(
					start_x + (col * TOTAL_CELL_STEP),
					start_y + (row * TOTAL_CELL_STEP)
				)

				formation_data.append({
					"enemy_path": ENEMIES[enemy_id],
					"position": spawn_pos,
					"row": row
				})

	return formation_data

class_name Level
extends Node

signal amount_sand_changed(value : int)
signal max_sand_reached

var data : LevelData = null

var amount_sand : int = 0

var grid : Grid = null
var spawner : Spawner = null
var entity : Entity = null
var target : Target = null

func _ready() -> void:
	grid = %Grid
	spawner = %Spawner
	entity = %Entity
	target = %Target
	
	spawner.spawned_sand.connect(sand_spawned)
	return

# loads level data and resets entity
func _load(level_data : LevelData) -> void:
	data = level_data
	amount_sand = 0
	grid.reset()
	grid.set_pixels(data.walls, Pixel.Type.WALL)
	spawner.enabled = true
	target.position = data.target_position
	entity.position = Vector2.ZERO
	return

# called when spawner spawns sand
func sand_spawned() -> void:
	amount_sand += 1
	amount_sand_changed.emit(amount_sand)
	if(amount_sand >= data.max_sand):
		spawner.enabled = false
		spawner.is_spawning = false
		max_sand_reached.emit()
	return

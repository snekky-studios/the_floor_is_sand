class_name Spawner
extends Node2D

signal spawned_sand()

@export var grid : Grid = null

var enabled : bool = true
var is_spawning : bool = false

func _ready() -> void:
	
	return

func _physics_process(delta: float) -> void:
	if(enabled and is_spawning):
		if(grid.set_pixel(Vector2i(position), Pixel.Type.SAND) == true):
			spawned_sand.emit()
	return

func update_position() -> void:
	position = get_global_mouse_position()
	return

func toggle_spawning() -> void:
	is_spawning = not is_spawning
	return

class_name Spawner
extends Node2D

signal spawned_sand

@export var grid : Grid = null

var is_spawning : bool = false

func _ready() -> void:
	
	return

func _physics_process(delta: float) -> void:
	if(is_spawning):
		grid.set_pixel_type(Vector2i(position), Pixel.Type.SAND)
		spawned_sand.emit()
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		position = get_global_mouse_position()
	elif(event is InputEventMouseButton and event.is_pressed()):
		is_spawning = not is_spawning
	return

class_name Spawner
extends Node2D

signal spawned_sand

@export var grid : Grid = null

var sand_amount_current : int = 0
var sand_amount_max : int = 1000
var is_spawning : bool = false

func _ready() -> void:
	
	return

func _physics_process(delta: float) -> void:
	if(is_spawning):
		if(grid.set_pixel(Vector2i(position), Pixel.Type.SAND) == true):
			spawned_sand.emit()
			sand_amount_current += 1
			if(sand_amount_current >= sand_amount_max):
				is_spawning = false
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		position = get_global_mouse_position()
	elif(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed() and sand_amount_current < sand_amount_max):
		is_spawning = not is_spawning
	return

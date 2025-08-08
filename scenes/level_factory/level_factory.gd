class_name LevelFactory
extends Node2D

const directory : String = "res://resources/level/"
const file_suffix : String = ".tres"

@export var file_name : String = ""
@export var level_name : String = ""
@export var max_sand : int = 0

var placing_walls : bool = false
var amount_sand : int = 0

var grid : Grid = null
var spawner : Spawner = null
var target : Target = null
var label_sand : Label = null

func _ready() -> void:
	grid = %Grid
	spawner = %Spawner
	target = %Target
	label_sand = %LabelSand
	
	spawner.spawned_sand.connect(update_sand)
	return

func _process(delta: float) -> void:
	if(placing_walls):
		var coordinate : Vector2i = Vector2i(get_global_mouse_position())
		grid.set_pixel(coordinate, Pixel.Type.WALL)
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.is_pressed()):
		_save()
	elif(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_MIDDLE and event.is_pressed()):
		placing_walls = not placing_walls
	return

func _save() -> void:
	var file_path : String = directory + file_name + file_suffix
	var level_data : LevelData = LevelData.new()
	level_data.name = level_name
	level_data.max_sand = max_sand
	level_data.walls = _get_walls()
	level_data.target_position = target.position
	var error : Error = ResourceSaver.save(level_data, file_path)
	assert(error == OK, "Save error: " + str(error))
	return

func _get_walls() -> Array[Vector2i]:
	var walls : Array[Vector2i] = []
	for row : int in range(Grid.NUM_ROWS):
		for col : int in range(Grid.NUM_COLS):
			var coordinate : Vector2i = Vector2i(col, row)
			if(grid.get_pixel_type(coordinate) == Pixel.Type.WALL):
				walls.append(coordinate)
	return walls

func update_sand() -> void:
	amount_sand += 1
	label_sand.text = str(amount_sand)
	return

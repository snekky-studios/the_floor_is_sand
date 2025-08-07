class_name Main
extends Node

var amount_sand : int = 0

var grid : Grid = null
var spawner : Spawner = null
var label_sand : Label = null

func _ready() -> void:
	grid = %Grid
	spawner = %Spawner
	label_sand = %LabelSand
	
	spawner.spawned_sand.connect(update_sand)
	return

func _physics_process(delta: float) -> void:
	
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.is_pressed()):
		grid.update()
		grid.display()
	return

func update_sand() -> void:
	amount_sand += 1
	label_sand.text = str(amount_sand)
	return

class_name Main
extends Node

var amount_sand : int = 0

var grid : Grid = null
var spawner : Spawner = null
var entity : Entity = null
var label_sand : Label = null

func _ready() -> void:
	grid = %Grid
	spawner = %Spawner
	entity = %Entity
	label_sand = %LabelSand
	
	spawner.spawned_sand.connect(update_sand)
	
	entity.found_target.connect(_on_entity_found_target)
	return

func _physics_process(delta: float) -> void:
	
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.is_pressed()):
		entity.start()
		pass
		#grid.update()
		#grid.display()
	return

func update_sand() -> void:
	amount_sand += 1
	label_sand.text = str(amount_sand)
	return

func _on_entity_found_target(success : bool) -> void:
	if(success):
		print("success")
	else:
		print("failure")
	return

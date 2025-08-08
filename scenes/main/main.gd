class_name Main
extends Node

const LEVEL_1 : LevelData = preload("res://resources/level/level_1.tres")
const LEVEL_2 : LevelData = preload("res://resources/level/level_2.tres")

const LEVELS : Array[LevelData] = [
	LEVEL_1,
	LEVEL_2
]

enum State
{
	START,
	IN_LEVEL,
	NEXT_LEVEL,
	REPEAT_LEVEL,
	END
}

var state : State = State.START
var level_current_index : int = 0

var level : Level = null
var ui : UI = null

func _ready() -> void:
	level = %Level
	ui = %UI
	
	#level._load(LEVELS[level_current_index])
	level.amount_sand_changed.connect(ui.update_progress_bar)
	level.max_sand_reached.connect(_on_max_sand_reached)
	level.entity.found_target.connect(_on_entity_found_target)
	
	#ui.set_level_name(LEVELS[level_current_index].name)
	#ui.set_progress_bar_max(LEVELS[level_current_index].max_sand)
	#ui.prompt_left_click()
	_on_state_changed()
	return

func _physics_process(delta: float) -> void:
	
	return

func _unhandled_input(event: InputEvent) -> void:
	if(event is InputEventMouseMotion):
		level.spawner.update_position()
	elif(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed()):
		level.spawner.toggle_spawning()
		ui.stop_mouse_prompt()
	if(event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.is_pressed()):
		if(not level.spawner.is_spawning):
			level.entity.start()
		ui.stop_mouse_prompt()
	return

func _on_max_sand_reached() -> void:
	if(state == State.START):
		ui.prompt_right_click()
	return

func _on_entity_found_target(success : bool) -> void:
	if(success):
		state = State.NEXT_LEVEL
		print("success")
	else:
		state = State.REPEAT_LEVEL
		print("failure")
	_on_state_changed()
	return

func _on_state_changed() -> void:
	match state:
		State.START:
			level_current_index = 0
			level._load(LEVELS[level_current_index])
			ui.set_level_name(LEVELS[level_current_index].name)
			ui.set_progress_bar_max(LEVELS[level_current_index].max_sand)
			ui.prompt_left_click()
		State.IN_LEVEL:
			pass
		State.NEXT_LEVEL:
			level_current_index += 1
			if(level_current_index >= LEVELS.size()):
				state = State.END
				_on_state_changed()
				return
			level._load(LEVELS[level_current_index])
			ui.set_level_name(LEVELS[level_current_index].name)
			ui.set_progress_bar_max(LEVELS[level_current_index].max_sand)
		State.REPEAT_LEVEL:
			level._load(LEVELS[level_current_index])
			ui.set_level_name(LEVELS[level_current_index].name)
			ui.set_progress_bar_max(LEVELS[level_current_index].max_sand)
		State.END:
			pass
		_:
			print("error: invalid state - ", state)
	return

class_name Entity
extends Node2D

signal found_target(success : bool)

enum State
{
	IDLE,
	MOVING_UP,
	MOVING_RIGHT,
	MOVING_DOWN,
	FOUND_TARGET,
	MISSED_TARGET
}

const ENTITY_WIDTH : int = 3
const ENTITY_HEIGHT : int = 4

@export var grid : Grid = null

var state : State = State.IDLE
var velocity : Vector2 = Vector2.ZERO
var is_moving : bool = false

func _ready() -> void:
	
	return

func _physics_process(delta: float) -> void:
	match state:
		State.IDLE, State.FOUND_TARGET, State.MISSED_TARGET:
			pass
		State.MOVING_UP, State.MOVING_RIGHT, State.MOVING_DOWN:
			position += velocity
			get_next_state()
		_:
			print("error: invalid state - ", state)
	return

func start() -> void:
	position = Vector2(-ENTITY_WIDTH, grid.get_sand_level_left_side())
	get_next_state()
	return

func get_next_state() -> void:
	var position_i : Vector2i = Vector2i(position)
	
	if(position_i.x < 0):
		# entity is still off the screen on the left, let it fully enter the screen
		state = State.MOVING_RIGHT
		_on_state_changed()
		return
	if(position_i.x + ENTITY_WIDTH >= Grid.NUM_COLS):
		# entity reached the right side of the screen without colliding with the target
		state = State.MISSED_TARGET
		_on_state_changed()
		return
	
	if(position_i.y < Grid.NUM_COLS and grid.get_pixel_type(position_i + Vector2i.RIGHT) == Pixel.Type.NONE):
		state = State.MOVING_DOWN
	elif(grid.get_pixel_type(position_i + Vector2i.RIGHT + Vector2i.UP) == Pixel.Type.NONE):
		state = State.MOVING_RIGHT
	elif(position_i.y > 0 and grid.get_pixel_type(position_i + Vector2i.RIGHT + Vector2i.UP + Vector2i.UP) == Pixel.Type.NONE):
		state = State.MOVING_UP
	else:
		print("error: no valid state.")
	
	_on_state_changed()
	return

func _on_state_changed() -> void:
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.MOVING_DOWN:
			velocity = Vector2.RIGHT + Vector2.DOWN
		State.MOVING_RIGHT:
			velocity = Vector2.RIGHT
		State.MOVING_UP:
			velocity = Vector2.RIGHT + Vector2.UP
		State.FOUND_TARGET:
			velocity = Vector2.ZERO
			found_target.emit(true)
		State.MISSED_TARGET:
			velocity = Vector2.ZERO 
			found_target.emit(false)
	return

func _on_area_entered(area: Area2D) -> void:
	if(area is Target):
		state = State.FOUND_TARGET
		_on_state_changed()
	return

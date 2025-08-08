class_name Entity
extends Node2D

signal found_target(success : bool)

enum State
{
	IDLE,
	MOVING_UP_RIGHT,
	MOVING_RIGHT,
	MOVING_DOWN_RIGHT,
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
		State.MOVING_UP_RIGHT, State.MOVING_RIGHT, State.MOVING_DOWN_RIGHT, State.MOVING_DOWN:
			position += velocity
			get_next_state()
		_:
			print("error: invalid state - ", state)
	return

func start() -> void:
	position = Vector2(-1, grid.get_sand_level(0))
	get_next_state()
	return

func get_next_state() -> void:
	var position_i : Vector2i = Vector2i(position)
	
	if(position_i.x < 0):
		# entity is still off the screen on the left, let it fully enter the screen
		state = State.MOVING_RIGHT
		_on_state_changed()
		return
	if(position_i.x >= Grid.NUM_COLS - 1):
		# entity reached the right side of the screen without colliding with the target
		state = State.MISSED_TARGET
		_on_state_changed()
		return
	
	var position_up_right_i : Vector2i = position_i + Vector2i.RIGHT + Vector2i.UP + Vector2i.UP
	var position_right_i : Vector2i = position_i + Vector2i.RIGHT + Vector2i.UP
	var position_down_right_i : Vector2i = position_i + Vector2i.RIGHT
	
	var is_up_right_open : bool = false
	var is_right_open : bool = false
	var is_down_right_open : bool = false
	var is_down_open : bool = false
	
	if(position_i.x > ENTITY_WIDTH):
		# all three positions below the entity are open
		is_down_open = (position_i.y < mini(grid.get_sand_level(position_i.x), mini(grid.get_sand_level(position_i.x - 1), grid.get_sand_level(position_i.x - 2))))
	if(position_i.y > 0):
		is_up_right_open = (grid.get_pixel_type(position_up_right_i) == Pixel.Type.NONE)
	if(position_i.y < Grid.NUM_COLS):
		is_down_right_open = (grid.get_pixel_type(position_down_right_i) == Pixel.Type.NONE)
	is_right_open = (grid.get_pixel_type(position_right_i) == Pixel.Type.NONE)
	
	if(is_down_open):
		state = State.MOVING_DOWN
	elif(is_up_right_open and not is_right_open):
		state = State.MOVING_UP_RIGHT
	elif(is_down_right_open):
		state = State.MOVING_DOWN_RIGHT
	elif(is_right_open):
		state = State.MOVING_RIGHT
	elif(is_up_right_open):
		state = State.MOVING_UP_RIGHT
	else:
		# cannot move in any valid direction, so target has been missed
		state = State.MISSED_TARGET
	
	_on_state_changed()
	return

func _on_state_changed() -> void:
	match state:
		State.IDLE:
			velocity = Vector2.ZERO
		State.MOVING_DOWN:
			velocity = Vector2.DOWN
		State.MOVING_DOWN_RIGHT:
			velocity = Vector2.RIGHT + Vector2.DOWN
		State.MOVING_RIGHT:
			velocity = Vector2.RIGHT
		State.MOVING_UP_RIGHT:
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

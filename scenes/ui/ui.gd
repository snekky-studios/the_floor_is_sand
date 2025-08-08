class_name UI
extends Control

var level_name : String = ""

var label_level_click : Label = null
var label_result : Label = null
var texture_progress_bar_sand : TextureProgressBar = null
var texture_rect_mouse : TextureRect = null
var animation_player : AnimationPlayer = null

func _ready() -> void:
	label_level_click = %LabelLevelClick
	label_result = %LabelResult
	texture_progress_bar_sand = %TextureProgressBarSand
	texture_rect_mouse = %TextureRectMouse
	animation_player = %AnimationPlayer
	
	texture_rect_mouse.hide()
	return

func set_level_name(value : String) -> void:
	level_name = value
	label_level_click.text = level_name
	return

func set_progress_bar_max(max_sand : int) -> void:
	texture_progress_bar_sand.max_value = max_sand
	texture_progress_bar_sand.value = texture_progress_bar_sand.max_value
	return

func update_progress_bar(amount_sand : int) -> void:
	texture_progress_bar_sand.value = texture_progress_bar_sand.max_value - amount_sand
	return

func stop_mouse_prompt() -> void:
	animation_player.stop()
	label_level_click.text = level_name
	texture_rect_mouse.hide()
	return

func prompt_left_click() -> void:
	label_level_click.text = "Click"
	animation_player.play("prompt_left_click")
	return

func prompt_right_click() -> void:
	label_level_click.text = "Click"
	animation_player.play("prompt_right_click")
	return

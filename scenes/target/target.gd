class_name Target
extends Area2D

var animation_player : AnimationPlayer = null

func _ready() -> void:
	animation_player = %AnimationPlayer
	animation_player.play("idle")
	return

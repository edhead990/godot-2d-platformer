class_name MoveComponent
extends Node

@export var crouch_raycast_1: RayCast2D
@export var crouch_raycast_2: RayCast2D

func get_movement_direction() -> float:
	return Input.get_axis("ui_left", "ui_right")

func should_jump() -> bool:
	return Input.is_action_just_pressed("ui_accept")

func stop_jump() -> bool:
	return Input.is_action_just_released("ui_accept")

func should_crouch() -> bool:
	return Input.is_action_pressed("ui_down")

func should_sprint() -> bool:
	return Input.is_action_pressed("sprint")

func should_roll() -> bool:
	return Input.is_action_just_pressed("roll")

func can_stand() -> bool:
	return not crouch_raycast_1.is_colliding() and not crouch_raycast_2.is_colliding()

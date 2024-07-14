class_name State
extends Node

@export var animation_name: String
@export var can_flip: bool = true

var character: CharacterBody2D
var playback: AnimationNodeStateMachinePlayback
var current_direction: float = 0.0
var move_component: MoveComponent
var was_on_floor: bool = false
var state_machine: CharacterStateMachine

signal transitioned

func enter():
	if animation_name:
		playback.travel(animation_name)

func exit():
	pass

func process_input(_event: InputEvent):
	pass

func update(_delta: float):
	pass

func physics_update(_delta: float):
	pass

func get_movement_direction() -> float:
	return move_component.get_movement_direction()

func should_jump() -> bool:
	return move_component.should_jump()

func stop_jump() -> bool:
	return move_component.stop_jump()

func should_crouch() -> bool:
	return move_component.should_crouch()

func should_sprint() -> bool:
	return move_component.should_sprint()

func should_roll() -> bool:
	return move_component.should_roll()

func can_stand() -> bool:
	return move_component.can_stand()


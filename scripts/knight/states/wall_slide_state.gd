class_name WallSlideState
extends State

@export var gravity: float = 200
@export var movement_speed: float = 150.0
@export var acceleration: float = 10.0
@export var jump_force_x: float = 250.0
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var particles: GPUParticles2D

func enter():
	super()
	character.velocity.y = 0.0
	state_machine.flip_sprite()
	particles.emitting = true
	
func exit():
	state_machine.set_current_direction(-current_direction)
	particles.emitting = false

func physics_update(_delta):
	var movement = current_direction
	
	if character.is_on_floor():
		transitioned.emit(self, idle_state)
	elif should_jump():
		character.velocity.x = -current_direction * jump_force_x
		transitioned.emit(self, jump_state)
	
	if not character.is_on_wall():
		transitioned.emit(self, fall_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)
	character.velocity.y += gravity * _delta

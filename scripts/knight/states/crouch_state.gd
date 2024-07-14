class_name CrouchState
extends State

@export var acceleration: float = 20.0
@export var jump_buffer: Timer
@export var idle_state: State
@export var move_state: State
@export var jump_state: State
@export var roll_state: State
@export var fall_state: State

func physics_update(_delta):
	if not should_crouch() and can_stand():
		transitioned.emit(self, idle_state)
	elif get_movement_direction():
		transitioned.emit(self, move_state)
	elif should_jump() and can_stand():
		transitioned.emit(self, jump_state)
	elif should_roll():
		transitioned.emit(self, roll_state)
	
	if character.is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		transitioned.emit(self, jump_state)
	
	if not character.is_on_floor():
		transitioned.emit(self, fall_state)

	character.velocity.x = move_toward(character.velocity.x, 0, acceleration)

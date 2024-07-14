class_name RatIdleState
extends State

@export var acceleration: float = 20.0
@export var jump_buffer: Timer
@export var walk_state: State
@export var jump_state: State
@export var fall_state: State

func physics_update(_delta):
	if get_movement_direction():
		transitioned.emit(self, walk_state)
	elif should_jump():
		transitioned.emit(self, jump_state)
	
	if character.is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		transitioned.emit(self, jump_state)
	
	if not character.is_on_floor():
		transitioned.emit(self, fall_state)

	character.velocity.x = move_toward(character.velocity.x, 0, acceleration)

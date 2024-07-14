class_name CrouchWalkState
extends State

@export var movement_speed: float = 60.0
@export var acceleration: float = 10.0
@export var coyote_timer: Timer
@export var jump_buffer: Timer
@export var idle_state: State
@export var jump_state: State
@export var run_state: State
@export var crouch_state: State
@export var roll_state: State
@export var fall_state: State

func physics_update(_delta):
	var movement = get_movement_direction() * movement_speed

	if not should_crouch() and can_stand():
		if movement == 0:
			transitioned.emit(self, idle_state)
		else:
			transitioned.emit(self, run_state)
	elif (
		should_jump()
		and can_stand()
		and (character.is_on_floor() or not coyote_timer.is_stopped())
	):
		coyote_timer.stop()
		transitioned.emit(self, jump_state)
	elif should_roll():
		transitioned.emit(self, roll_state)
	elif movement == 0:
		transitioned.emit(self, crouch_state)
	
	if not character.is_on_floor() and was_on_floor:
		coyote_timer.start()
	elif not character.is_on_floor() and coyote_timer.is_stopped():
		transitioned.emit(self, fall_state)
	elif character.is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		transitioned.emit(self, jump_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)

class_name RatWalkState
extends State

@export var fast_movement_speed: float = 225.0
@export var movement_speed: float = 150.0
@export var acceleration: float = 10.0
@export var coyote_timer: Timer
@export var jump_buffer: Timer
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State

var speed: float

func physics_update(_delta):
	speed = movement_speed

	var direction = get_movement_direction()
	var movement = direction * speed
	
	if should_jump():
		if character.is_on_floor() or not coyote_timer.is_stopped():
			coyote_timer.stop()
			transitioned.emit(self, jump_state)
	elif (
		# If the player has stopped or changed direction
		movement == 0
		or (character.velocity.x > 0 and current_direction > 0 and movement < 0)
		or (character.velocity.x < 0 and current_direction < 0 and movement > 0)
	):
		transitioned.emit(self, idle_state)
	
	if not character.is_on_floor() and was_on_floor:
		coyote_timer.start()
	elif not character.is_on_floor() and coyote_timer.is_stopped():
		transitioned.emit(self, fall_state)
	elif character.is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		transitioned.emit(self, jump_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)

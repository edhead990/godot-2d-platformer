class_name RunState
extends State

@export var animation_tree: AnimationTree
@export var fast_movement_speed: float = 225.0
@export var movement_speed: float = 150.0
@export var acceleration: float = 10.0
@export var min_speed_to_slide: float = 180.0
@export var coyote_timer: Timer
@export var jump_buffer: Timer
@export var idle_state: State
@export var jump_state: State
@export var crouch_state: State
@export var slide_state: State
@export var roll_state: State
@export var fall_state: State
@export var brake_state: State

var speed: float

func physics_update(_delta):
	if should_sprint():
		speed = fast_movement_speed
		animation_tree["parameters/run/TimeScale/scale"] = 1.5
	else:
		speed = movement_speed
		animation_tree["parameters/run/TimeScale/scale"] = 1.0

	var direction = get_movement_direction()
	var movement = direction * speed
	
	if should_jump():
		if character.is_on_floor() or not coyote_timer.is_stopped():
			coyote_timer.stop()
			transitioned.emit(self, jump_state)
	elif should_crouch():
		if abs(character.velocity.x) >= min_speed_to_slide:
			transitioned.emit(self, slide_state)
		else:
			transitioned.emit(self, crouch_state)
	elif not can_stand():
		transitioned.emit(self, crouch_state)
	elif should_roll():
		transitioned.emit(self, roll_state)
	elif (
		# If the player has stopped or changed direction
		movement == 0
		or (character.velocity.x > 0 and current_direction > 0 and movement < 0)
		or (character.velocity.x < 0 and current_direction < 0 and movement > 0)
	):
		# Transition to idle if moving slowly
		if abs(character.velocity.x) < movement_speed:
			transitioned.emit(self, idle_state)
		# Hard brake when moving fast
		elif abs(character.velocity.x) > movement_speed:
			animation_tree.set("parameters/brake/blend_position", 1.0)
		# Quick brake when moving
		else:
			animation_tree.set("parameters/brake/blend_position", -1.0)
		transitioned.emit(self, brake_state)
	
	if not character.is_on_floor() and was_on_floor:
		coyote_timer.start()
	elif not character.is_on_floor() and coyote_timer.is_stopped():
		transitioned.emit(self, fall_state)
	elif character.is_on_floor() and not jump_buffer.is_stopped():
		jump_buffer.stop()
		transitioned.emit(self, jump_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)

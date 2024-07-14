class_name RatJumpState
extends State

@export var movement_speed: float = 150.0
@export var acceleration: float = 10.0
@export var jump_force: float = 500.0
@export var idle_state: State
@export var walk_state: State
@export var fall_state: State

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity") / 1.2
var speed: float

func enter():
	super()
	character.velocity.y = -jump_force

func physics_update(_delta):
	speed = movement_speed

	var direction = get_movement_direction()
	var movement = direction * speed
	
	if stop_jump():
		character.velocity.y = -jump_force / 4
	
	if character.is_on_floor():
		if movement != 0:
			transitioned.emit(self, walk_state)
		else:
			transitioned.emit(self, idle_state)
	
	if character.velocity.y > 0:
		transitioned.emit(self, fall_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)
	character.velocity.y += gravity * _delta
	

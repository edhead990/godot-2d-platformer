class_name RatFallState
extends State

@export var movement_speed: float = 150.0
@export var acceleration: float = 10.0
@export var jump_buffer: Timer
@export var idle_state: State
@export var jump_state: State
@export var walk_state: State

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: float

func enter():
	super()

func physics_update(_delta):
	speed = movement_speed

	var direction = get_movement_direction()
	var movement = direction * speed
	
	if should_jump() and not character.is_on_floor():
		jump_buffer.start()

	if character.is_on_floor():
		if movement != 0:
			transitioned.emit(self, walk_state)
		else:
			transitioned.emit(self, idle_state)
	
	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)
	character.velocity.y += gravity * _delta

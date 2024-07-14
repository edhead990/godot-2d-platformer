class_name FallState
extends State

@export var movement_speed: float = 150.0
@export var fast_movement_speed: float = 175.0
@export var acceleration: float = 10.0
@export var jump_buffer: Timer
@export var idle_state: State
@export var jump_state: State
@export var crouch_state: State
@export var crouch_walk_state: State
@export var run_state: State
@export var wall_slide_state: State

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var speed: float

func enter():
	super()

func physics_update(_delta):
	if should_sprint():
		speed = fast_movement_speed
	else:
		speed = movement_speed

	var direction = get_movement_direction()
	var movement = direction * speed
	
	if should_jump() and not character.is_on_floor():
		jump_buffer.start()

	if character.is_on_floor():
		if movement != 0:
			if should_crouch():
				transitioned.emit(self, crouch_walk_state)
			else:
				transitioned.emit(self, run_state)
		elif should_crouch():
			transitioned.emit(self, crouch_state)
		else:
			transitioned.emit(self, idle_state)
	
	if character.is_on_wall() and character.get_wall_normal().x == -direction:
		transitioned.emit(self, wall_slide_state)

	character.velocity.x = move_toward(character.velocity.x, movement, acceleration)
	character.velocity.y += gravity * _delta

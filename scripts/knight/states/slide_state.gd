class_name SlideState
extends State

@export var movement_speed: float = 150.0
@export var max_movement_speed: float = 350.0
@export var acceleration: float = 10.0
@export var slide_velocity_factor: float = 1.5
@export var idle_state: State
@export var crouch_state: State
@export var fall_state: State

var direction: float = 0.0

func enter():
	super()
	# Store the direction the player was heading
	direction = current_direction
	# Apply the slide force based on the players current velocity
	var speed = clamp(abs(character.velocity.x) * slide_velocity_factor, movement_speed, max_movement_speed)
	character.velocity.x = direction * speed

func physics_update(_delta):
	if abs(character.velocity.x) > movement_speed / 2:
		var movement = get_movement_direction() * movement_speed
		character.velocity.x = move_toward(character.velocity.x, movement / 2, acceleration)
	elif should_crouch() or not can_stand():
		transitioned.emit(self, crouch_state)
	else:
		transitioned.emit(self, idle_state)
	
	if not character.is_on_floor():
		transitioned.emit(self, fall_state)

# Lock the movement direction while in this state
func get_movement_direction() -> float:
	return direction

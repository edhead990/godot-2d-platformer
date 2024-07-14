class_name BrakeState
extends State

@export var acceleration: float = 10.0
@export var idle_state: State
@export var fall_state: State

var direction: float = 0.0

func enter():
	super()
	# Store the direction the player was heading
	direction = current_direction

func physics_update(_delta):
	character.velocity.x = move_toward(character.velocity.x, 0, acceleration)
	
	if character.velocity.x == 0:
		transitioned.emit(self, idle_state)
	
	if not character.is_on_floor():
		transitioned.emit(self, fall_state)

# Lock the movement direction while in this state
func get_movement_direction() -> float:
	return direction

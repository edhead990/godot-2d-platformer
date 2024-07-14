class_name RollState
extends State

@export var movement_speed: float = 50.0
@export var acceleration: float = 10.0
@export var default_roll_speed: float = 225.0
@export var roll_velocity_factor: float = 1.5
@export var animation_tree: AnimationTree
@export var idle_state: State
@export var crouch_state: State

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: float = 0.0

func enter():
	super()
	# Interrupt crouching and sliding
	var current_animation = playback.get_current_node()
	if current_animation == 'crouch_transition' or current_animation == 'slide_end':
		playback.start('roll')
	# Store the direction the player was heading
	direction = current_direction
	# Apply the initial roll velocity based on the player's current velocity
	if abs(character.velocity.x) < default_roll_speed:
		character.velocity.x = direction * default_roll_speed * roll_velocity_factor
	else:
		character.velocity.x = character.velocity.x * roll_velocity_factor

func physics_update(_delta):
	character.velocity.x = move_toward(character.velocity.x, direction * movement_speed, acceleration)
	
	if not character.is_on_floor():
		character.velocity.y += gravity * _delta
	
	# Found an issue where the "animation_finished" signal isn't fired when the player spams the roll button.
	# Setting the advance property of the AnimationTree transitions to "Auto" seems to fix it.
	# I've setup an advance condition for each transition so the correct animation is playing after the roll animation.
	if should_crouch() or not can_stand():
		animation_tree.set('parameters/conditions/idle', false)
		animation_tree.set('parameters/conditions/crouch', true)
	else:
		animation_tree.set('parameters/conditions/idle', true)
		animation_tree.set('parameters/conditions/crouch', false)

# Lock the movement direction while in this state
func get_movement_direction() -> float:
	return direction

func _on_animation_tree_animation_finished(anim_name):
	if anim_name == animation_name:
		if should_crouch() or not can_stand():
			transitioned.emit(self, crouch_state)
		else:
			transitioned.emit(self, idle_state)

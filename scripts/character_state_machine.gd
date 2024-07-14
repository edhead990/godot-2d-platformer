class_name CharacterStateMachine
extends Node

@export var character: CharacterBody2D
@export var animation_tree: AnimationTree
@export var move_component: MoveComponent
@export var initial_state: State

var current_state: State
var current_direction: float = 1.0

func _ready():
	animation_tree.active = true
	for child in get_children():
		if child is State:
			child.character = character
			child.playback = animation_tree.get("parameters/playback")
			child.move_component = move_component
			child.transitioned.connect(on_state_transition)
			child.state_machine = self
		else:
			push_warning("Child " + child.name + " is not a State for " + self.name)
	if initial_state:
		change_state(initial_state)

func _process(delta):
	if current_state:
		current_state.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	current_state.process_input(event)

func _physics_process(delta):
	if current_state:
		# Handle changing direction
		if current_state.can_flip:
			var direction = current_state.get_movement_direction()
			if direction != 0 and direction != current_direction:
				current_direction = direction
				current_state.current_direction = direction
				flip_sprite()
		
		current_state.physics_update(delta)
		current_state.was_on_floor = character.is_on_floor()
		
	character.move_and_slide()

func change_state(new_state: State):
	if current_state is State:
		current_state.exit()
	new_state.current_direction = current_direction
	new_state.enter()
	current_state = new_state

func on_state_transition(state: State, new_state: State):
	if state != current_state or current_state == new_state:
		return
	change_state(new_state)

func flip_sprite() -> void:
	character.scale.x = -character.scale.x
	var label = character.get_node("LabelNode")
	label.scale.x = -label.scale.x

func set_current_direction(direction: float) -> void:
	current_direction = direction

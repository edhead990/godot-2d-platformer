class_name RatMovementComponent
extends MoveComponent

func should_crouch() -> bool:
	return false

func should_sprint() -> bool:
	return Input.is_action_pressed("sprint")

func should_roll() -> bool:
	return false

func can_stand() -> bool:
	return true

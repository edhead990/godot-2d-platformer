extends CharacterBody2D

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_home"):
		get_tree().reload_current_scene()

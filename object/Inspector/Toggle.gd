extends Node2D

var pressed = false

var sprite = false

signal toggle(pressed)

func _physics_process(_delta):
		
	if !pressed == sprite:
		_animation(pressed)
		sprite = pressed

func _animation(active : bool):
	
	if active == true:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("On")
	else:
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Off")

func _on_Toggle_button_down():
	
	if pressed == true:
		
		Sound._play("Laser")
		pressed = false
		
	else:
		
		Sound._play("Laser")
		pressed = true
	
	emit_signal("toggle", pressed)

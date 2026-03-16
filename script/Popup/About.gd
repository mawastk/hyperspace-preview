extends Node2D

func _reset():
	return

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Continue_button_down():
	Sound._play("Select")

func _on_Continue_button_up():
	Sound._play("Powerup")
	OS.shell_open("https://discord.com/invite/Mcj6RQurhB")

func _on_Canvas_button_down():
	Notice._show("canvasgirl")

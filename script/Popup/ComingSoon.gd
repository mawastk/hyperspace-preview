extends Node2D

func _reset():
	return

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

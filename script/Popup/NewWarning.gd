extends Node2D

func _reset():
	return

func _ready():
	return
	
func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Cancel_button_down():
	Sound._play("Select")

func _on_Cancel_button_up():
	get_node("../../../")._close()

func _on_Create_button_up():
	get_node("../../../")._send(self.name, "New", 0)

func _on_Create_button_down():
	Sound._play("Select")

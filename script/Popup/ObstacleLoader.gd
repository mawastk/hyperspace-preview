extends Node2D

func _reset():
	return

func _selected(obstacle : String):
	get_node("../../../")._send(self.name, "Select", obstacle)

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_All_button_down():
	Sound._play("Select")

func _on_All_button_up():
	Sound._play("Show")

func _on_Favorite_button_down():
	Sound._play("Select")

func _on_Favorite_button_up():
	Sound._play("Show")

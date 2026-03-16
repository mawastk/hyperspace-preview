extends Node2D

var selected = "ballfrenzy"

func _reset():
	$Select.disabled = true
	selected = "ballfrenzy"

func _physics_process(_delta):
	$Selected.text = selected

func _on_Ballfrenzy_button_down():
	Sound._play("Select")

func _on_Ballfrenzy_button_up():
	selected = "ballfrenzy"
	Sound._play("Change")
	$Select.disabled = false

func _on_Nitroballs_button_down():
	Sound._play("Select")

func _on_Nitroballs_button_up():
	selected = "nitroballs"
	Sound._play("Change")
	$Select.disabled = false

func _on_Slowmotion_button_down():
	Sound._play("Select")

func _on_Slowmotion_button_up():
	selected = "slowmotion"
	Sound._play("Change")
	$Select.disabled = false

func _on_Extraball_button_down():
	Sound._play("Select")
	
func _on_Extraball_button_up():
	selected = "extraball"
	Sound._play("Change")
	$Select.disabled = false

func _on_Multiball_button_down():
	Sound._play("Select")

func _on_Multiball_button_up():
	selected = "multiball"
	$Select.disabled = false
	Sound._play("Change")

func _on_Select_button_down():
	Sound._play("Select")

func _on_Select_button_up():
	get_node("../../../")._send(self.name, "Select", selected)

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

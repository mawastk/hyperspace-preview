extends Node2D

var error = Error.new()

func _reset():
	
	$Error.text = ""
	
	var error_list = get_node("../../../").argument
	for i in range(error_list.size()):
		$Error.text += error.error_text[error_list[i]] + "\n\n"

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()	

func _on_Continue_button_down():
	Sound._play("Select")

func _on_Continue_button_up():
	get_node("../../../")._close()

func _on_Copy_button_down():
	Sound._play("Select")

func _on_Copy_button_up():
	OS.set_clipboard($Error.text)
	Sound._play("Change")

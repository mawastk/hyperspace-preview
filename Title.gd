extends Node2D

var selected = false

func _on_Editor_button_down():
	Sound._play("Select")

func _on_Editor_button_up():
	
	if selected:
		return
	
	SceneAnimate._change_scene("res://Main.tscn")
	selected = true

func _on_About_button_down():
	Sound._play("Select")

func _on_About_button_up():
	GlobalPopup._pop("About")

func _on_Online_button_down():
	Sound._play("Select")

func _on_Online_button_up():
	GlobalPopup._pop("ComingSoon")

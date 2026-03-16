extends Node2D

var text = {
	
	invaildvalue = {
		title = "Editor",
		text = "Invalid value",
		color = "red"
	},
	
	exported = {
		title = "Editor",
		text = "Segment saved",
		color = "white"
	},
	
	opened = {
		title = "Editor",
		text = "Segment opened",
		color = "white"
	},
	
	inspector_error = {
		title = "Inspector",
		text = "Please select an object.",
		color = "red"
	},
	
	duplicate_error = {
		title = "Editor",
		text = "Please select an object.",
		color = "red"
	},
	
	canvasgirl = {
		title = "Mawa",
		text = "That's me.",
		color = "white"
	}
	
}

func _show(notice : String):
	
	$CanvasLayer/Notice/Title.text = text[notice].title
	$CanvasLayer/Notice/Text.text = text[notice].text
	
	if text[notice].color == "red":
		$CanvasLayer/Notice/Text.modulate = Color("b62e2e")
		Sound._play("Single")
	else:
		$CanvasLayer/Notice/Text.modulate = Color("b6b6b6")
		Sound._play("Multiple")
	 
	$AnimationPlayer.stop()
	$AnimationPlayer.play("Show")

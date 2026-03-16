extends Node2D

var info = {}

func _reset():
	
	info = get_node("../../../").argument
	
	$Segsizex.text = str(info.size.x)
	$Segsizey.text = str(info.size.y)
	$Segsizez.text = str(info.size.z)
	$TemplateName.text = info.template
	
	$Segsizex.editable = true
	$Segsizey.editable = true
	$Segsizez.editable = true
	
	if info.autosize == true:
		
		$Segsizex.editable = false
		$Segsizey.editable = false
		$Segsizez.editable = false
	
	$SegsizeAuto.pressed = info.autosize

func _check():
	
	if int($Segsizex.text) < 1:
		return false
		
	if int($Segsizey.text) < 1:
		return false
		
	if int($Segsizez.text) < 1:
		return false
	
	if $TemplateName.text.empty():
		return false
	
	info.size = {
		x = int($Segsizex.text),
		y = int($Segsizey.text),
		z = int($Segsizez.text)
	}
	info.template = $TemplateName.text
	info.autosize = $SegsizeAuto.pressed
	
	return true

func _on_Continue_button_down():
	Sound._play("Select")

func _on_Continue_button_up():
	
	if _check() == true:
		get_node("../../../")._send(self.name, "SegmentOption", info)
	else:
		Notice._show("invaildvalue")

func _on_Segsizex_text_changed(new_text):
	if int($Segsizex.text) < 1:
		$Segsizex.text = str(info.size.x)

func _on_Segsizey_text_changed(new_text):
	if int($Segsizey.text) < 1:
		$Segsizey.text = str(info.size.y)

func _on_Segsizez_text_changed(new_text):
	if int($Segsizez.text) < 1:
		$Segsizez.text = str(info.size.z)

func _on_SegsizeAuto_toggled(button_pressed):
	
	if button_pressed:
		$Segsizex.editable = false
		$Segsizey.editable = false
		$Segsizez.editable = false
	else:
		$Segsizex.editable = true
		$Segsizey.editable = true
		$Segsizez.editable = true

extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	$Type.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()

func _on_PositionX_text_changed(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.x = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_PositionY_text_changed(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.y = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_PositionZ_text_changed(new_text):
	var value = float(new_text)
	var pos = root._get_object(inspector.selected_id).Position
	pos.z = value
	root._set_object(inspector.selected_id, "Position", pos, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_TypeMenu_button_down():
	Sound._play("Select")

func _on_TypeMenu_button_up():
	GlobalPopup._pop("Powerup")

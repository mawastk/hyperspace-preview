extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	$Type.text = ""
	$TemplateName.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	$RotationX.release_focus()
	$RotationY.release_focus()
	$RotationZ.release_focus()
	
	$Raycast.pressed = false
	$Static.pressed = false

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

func _on_RotationX_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.x = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_RotationY_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.y = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_RotationZ_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var rot = root._get_object(inspector.selected_id).Rotation
	rot.z = deg2rad(value)
	root._set_object(inspector.selected_id, "Rotation", rot, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Raycast_toggle(pressed):
	root._set_object(inspector.selected_id, "Raycast", pressed, false)
	root._sync_object(inspector.selected_id)

func _on_Static_toggle(pressed):
	root._set_object(inspector.selected_id, "Statc", pressed, false)
	root._sync_object(inspector.selected_id)

func _on_Template_button_down():
	Sound._play("Select")

func _on_Template_button_up():
	GlobalPopup._pop("CrystalTemplate", [$TemplateName.text, "CrystalInspector"])

func _on_TypeChange_button_down():
	return

func _on_TypeChange_button_up():
	var type = root._get_object(inspector.selected_id).Name
	
	if type == "scoremulti":
		Sound._play("Crystal_1")
		type = "scoretop"
	
	elif type == "scoretop":
		Sound._play("Crystal_2")
		type = "scorediamond"
	
	elif type == "scorediamond":
		Sound._play("Crystal_3")
		type = "scorestar"
	
	elif type == "scorestar":
		Sound._play("Crystal_4")
		type = "scoremulti"
	
	root._set_object(inspector.selected_id, "Name", type, false)
	root._sync_object(inspector.selected_id)
	
	inspector._update(root._get_object(inspector.selected_id), inspector.selected_id)

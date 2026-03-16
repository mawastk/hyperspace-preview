extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	$RotationX.text = ""
	$RotationY.text = ""
	$RotationZ.text = ""
	$Maxwidth.text = ""
	$Height.text = ""
	$Thickness.text = ""
	$Move.text = ""
	$Speed.text = ""
	$Offset.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	$RotationX.release_focus()
	$RotationY.release_focus()
	$RotationZ.release_focus()
	$Maxwidth.release_focus()
	$Height.release_focus()
	$Thickness.release_focus()
	$Move.release_focus()
	$Speed.release_focus()
	$Offset.release_focus()
	
	$Blocker.pressed = false

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

func _on_Maxwidth_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Maxwidth", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Height_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Height", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Thickness_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	root._set_object(inspector.selected_id, "Thickness", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Move_text_changed(new_text):
	var value = Syntax._check_nominus_allowedzero(float(new_text))
	root._set_object(inspector.selected_id, "Move", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Speed_text_changed(new_text):
	var value = float(new_text)
	root._set_object(inspector.selected_id, "Speed", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_Offset_text_changed(new_text):
	var value = Syntax._check_nominus_allowedzero(float(new_text))
	root._set_object(inspector.selected_id, "Offset", value, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot") 

func _on_Blocker_toggle(pressed):
	root._set_object(inspector.selected_id, "Blocker", pressed, false)
	root._sync_object(inspector.selected_id)

func _on_Template_button_down():
	Sound._play("Select")

func _on_Template_button_up():
	GlobalPopup._pop("GlassTemplate", [$TemplateName.text, "BarInspector"])

extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	$SizeX.text = ""
	$SizeY.text = ""
	$DecalID.text = ""
	$ColorR.text = ""
	$ColorG.text = ""
	$ColorB.text = ""
	$RotationX.text = ""
	$RotationY.text = ""
	$RotationZ.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	$SizeX.release_focus()
	$SizeY.release_focus()
	$ColorR.release_focus()
	$ColorG.release_focus()
	$ColorB.release_focus()
	$RotationX.release_focus()
	$RotationY.release_focus()
	$RotationZ.release_focus()

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

func _on_SizeX_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var size = root._get_object(inspector.selected_id).Size
	size.x = value
	root._set_object(inspector.selected_id, "Size", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_SizeY_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var size = root._get_object(inspector.selected_id).Size
	size.y = value
	root._set_object(inspector.selected_id, "Size", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_ColorR_text_changed(new_text):
	var value = Syntax._check_rawcolor(float(new_text))
	var color = {r = 1.0, g = 1.0, b = 1.0}
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	color.r = value
		
	root._set_object(inspector.selected_id, "Color", color, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_ColorG_text_changed(new_text):
	var value = Syntax._check_rawcolor(float(new_text))
	var color = {r = 1.0, g = 1.0, b = 1.0}
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	color.g = value
		
	root._set_object(inspector.selected_id, "Color", color, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_ColorB_text_changed(new_text):
	var value = Syntax._check_rawcolor(float(new_text))
	var color = {r = 1.0, g = 1.0, b = 1.0}
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	color.b = value
		
	root._set_object(inspector.selected_id, "Color", color, false)
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

func _on_Template_button_down():
	Sound._play("Select")

func _on_ColorMenu_button_down():
	Sound._play("Select")

func _on_Template_button_up():
	GlobalPopup._pop("DecalLoader")

func _on_ColorMenu_button_up():
	var color = Color(1.0, 1.0, 1.0)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	GlobalPopup._pop("ColorPicker", [color, "DecalInspector"])

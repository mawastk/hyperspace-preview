extends Node2D

onready var inspector = get_parent()
onready var root = get_node("../../../")

func _reset():
	$PositionX.text = ""
	$PositionY.text = ""
	$PositionZ.text = ""
	$SizeX.text = ""
	$SizeY.text = ""
	$SizeZ.text = ""
	$Tile.text = ""
	$ColorR.text = ""
	$ColorG.text = ""
	$ColorB.text = ""
	$TileSizeX.text = ""
	$TileSizeY.text = ""
	$TileSizeZ.text = ""
	
	$PositionX.release_focus()
	$PositionY.release_focus()
	$PositionZ.release_focus()
	$SizeX.release_focus()
	$SizeY.release_focus()
	$SizeZ.release_focus()
	$ColorR.release_focus()
	$ColorG.release_focus()
	$ColorB.release_focus()
	$Tile.release_focus()
	$TileSizeX.release_focus()
	$TileSizeY.release_focus()
	$TileSizeZ.release_focus()

func _on_Template_button_down():
	Sound._play("Select")

func _on_Template_button_up():
	GlobalPopup._pop("BoxTemplate", [$TemplateName.text, "BoxInspector"])

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

func _on_SizeZ_text_changed(new_text):
	var value = Syntax._check_nominus(float(new_text))
	var size = root._get_object(inspector.selected_id).Size
	size.z = value
	root._set_object(inspector.selected_id, "Size", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_TileMenu_button_down():
	Sound._play("Select")

func _on_TileMenu_button_up():
	GlobalPopup._pop("TileLoader")

func _on_Tile_text_changed(new_text):
	if new_text == "":
		root._clear_object(inspector.selected_id, "Tile", false)
		root._sync_object(inspector.selected_id)
	else:
		var id = Syntax._check_tilerange(int(new_text))
		root._set_object(inspector.selected_id, "Tile", id, false)
		root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_ColorMenu_button_down():
	Sound._play("Select")

func _on_ColorMenu_button_up():
	var color = Color(1.0, 1.0, 1.0)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	GlobalPopup._pop("ColorPicker", [color, "BoxInspector"])

func _on_ColorR_text_changed(new_text):
	var value = Syntax._check_rawcolor(float(new_text))
	var color = Color(1.0, 1.0, 1.0)
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
	var color = Color(1.0, 1.0, 1.0)
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
	var color = Color(1.0, 1.0, 1.0)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("Color"):
		color.r = object.Color.r
		color.g = object.Color.g
		color.b = object.Color.b
	
	color.b = value
		
	root._set_object(inspector.selected_id, "Color", color, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

func _on_TileSizeX_text_changed(new_text):
	var value = int(Syntax._check_nominus(float(new_text)))
	var size = Vector3(1, 1, 1)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("TileSize"):
		size.x = object.TileSize.x
		size.y = object.TileSize.y
		size.z = object.TileSize.z
	
	if value == 0:
		value = 1
	
	size.x = value
		
	root._set_object(inspector.selected_id, "TileSize", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")


func _on_TileSizeY_text_changed(new_text):
	var value = int(Syntax._check_nominus(float(new_text)))
	var size = Vector3(1, 1, 1)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("TileSize"):
		size.x = object.TileSize.x
		size.y = object.TileSize.y
		size.z = object.TileSize.z
	
	if value == 0:
		value = 1
	
	size.y = value
		
	root._set_object(inspector.selected_id, "TileSize", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")


func _on_TileSizeZ_text_changed(new_text):
	var value = int(Syntax._check_nominus(float(new_text)))
	var size = Vector3(1, 1, 1)
	var object = root._get_object(inspector.selected_id)
	
	if object.has("TileSize"):
		size.x = object.TileSize.x
		size.y = object.TileSize.y
		size.z = object.TileSize.z
	
	if value == 0:
		value = 1
	
	size.z = value
		
	root._set_object(inspector.selected_id, "TileSize", size, false)
	root._sync_object(inspector.selected_id)
	Sound._play("Dot")

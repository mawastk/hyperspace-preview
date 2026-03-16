extends Node2D

onready var root = get_node("../../")

var icon = {
	box = load("res://image/icon/box.png"),
	decal = load("res://image/icon/decal.png"),
	powerup = load("res://image/icon/powerup.png"),
	scoretop = load("res://image/icon/scoretop.png"),
	scorediamond = load("res://image/icon/scorediamond.png"),
	scorestar = load("res://image/icon/scorestar.png"),
	scoremulti = load("res://image/icon/scoremulti.png"),
	bar = load("res://image/icon/bar.png"),
	sweeper = load("res://image/icon/sweeper.png"),
	foldwindow = load("res://image/icon/foldwindow.png"),
	beatwindow = load("res://image/icon/beatwindow.png"),
	rotor = load("res://image/icon/rotor.png"),
	revolver = load("res://image/icon/revolver.png")
}

var active = false

var selected
var selected_id

func _update(object, id):
	
	selected_id = id
	
	$Box.hide()
	$Decal.hide()
	$Powerup.hide()
	$Score.hide()
	$Bar.hide()
	$Sweeper.hide()
	$Foldwindow.hide()
	$Beatwindow.hide()
	$Rotor.hide()
	$Revolver.hide()
	
	if object.Name == "box":
		
		$Box.show()
		$Icon.texture = icon.box
		
	elif object.Name == "decal":
		
		$Decal.show()
		$Icon.texture = icon.decal
		
	elif object.Name == "powerup":
		
		$Powerup.show()
		$Icon.texture = icon.powerup
	
	elif object.Name.begins_with("score"):
		
		$Score.show()
		$Icon.texture = icon[object.Name]
		
	elif object.Name == "bar":
		
		$Bar.show()
		$Icon.texture = icon[object.Name]
		
	elif object.Name == "sweeper":
		
		$Sweeper.show()
		$Icon.texture = icon[object.Name]
	
	elif object.Name == "foldwindow":
		
		$Foldwindow.show()
		$Icon.texture = icon[object.Name]
		
	elif object.Name == "beatwindow":
		
		$Beatwindow.show()
		$Icon.texture = icon[object.Name]
		
	elif object.Name == "rotor":
		
		$Rotor.show()
		$Icon.texture = icon[object.Name]
		
	elif object.Name == "revolver":
		
		$Revolver.show()
		$Icon.texture = icon[object.Name]
	
	if object.Name == "box":
		
		$Box/TemplateName.text = object.Template
		
		$Box/PositionX.text = str(object.Position.x)
		$Box/PositionY.text = str(object.Position.y)
		$Box/PositionZ.text = str(object.Position.z)
		
		$Box/SizeX.text = str(object.Size.x)
		$Box/SizeY.text = str(object.Size.y)
		$Box/SizeZ.text = str(object.Size.z)
		
		if object.has("Color"):
			
			$Box/ColorR.text = str(object.Color.r)
			$Box/ColorG.text = str(object.Color.g)
			$Box/ColorB.text = str(object.Color.b)
		
		if object.has("TileSize"):
			
			$Box/TileSizeX.text = str(object.TileSize.x)
			$Box/TileSizeY.text = str(object.TileSize.y)
			$Box/TileSizeZ.text = str(object.TileSize.z)
		
		$ObjectName.text = "Box_" + str(id)
		
		if object.has("Tile"):
			
			$Box/Tile.text = str(object.Tile)
			
	elif object.Name == "decal":
		
		$Decal/PositionX.text = str(object.Position.x)
		$Decal/PositionY.text = str(object.Position.y)
		$Decal/PositionZ.text = str(object.Position.z)
		
		$Decal/SizeX.text = str(object.Size.x)
		$Decal/SizeY.text = str(object.Size.y)
		
		if object.has("Rotation"):
			$Decal/RotationX.text = str(rad2deg(object.Rotation.x))
			$Decal/RotationY.text = str(rad2deg(object.Rotation.y))
			$Decal/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		if object.has("Color"):
			$Decal/ColorR.text = str(object.Color.r)
			$Decal/ColorG.text = str(object.Color.g)
			$Decal/ColorB.text = str(object.Color.b)
		
		$Decal/DecalID.text = str(object.Tile)
		
		$ObjectName.text = "Decal_" + str(id)
		
	elif object.Name == "powerup":
		
		$Powerup/PositionX.text = str(object.Position.x)
		$Powerup/PositionY.text = str(object.Position.y)
		$Powerup/PositionZ.text = str(object.Position.z)

		$Powerup/Type.text = str(object.Type)
		
		$ObjectName.text = "Powerup_" + str(id)
		
	elif object.Name.begins_with("score"):
		
		$Score/PositionX.text = str(object.Position.x)
		$Score/PositionY.text = str(object.Position.y)
		$Score/PositionZ.text = str(object.Position.z)
		
		$Score/RotationX.text = str(rad2deg(object.Rotation.x))
		$Score/RotationY.text = str(rad2deg(object.Rotation.y))
		$Score/RotationZ.text = str(rad2deg(object.Rotation.z))

		$Score/Type.text = str(object.Name)
		
		$Score/TemplateName.text = str(object.Template)
		
		$Score/Raycast.hide()
		$Score/Static.hide()
		$Score/StaticText.hide()
		$Score/BlackArea3.hide()
		
		if object.Name == "scoretop":
			$Score/Raycast.show()
			$Score/Static.show()
			$Score/StaticText.show()
			$Score/BlackArea3.show()
			
			$Score/Raycast.pressed = object.Raycast
			$Score/Static.pressed = object.Static
			
		else:
			$Score/Raycast.show()
			
			$Score/Raycast.pressed = object.Raycast
		
		$ObjectName.text = "Score_" + str(id)
		
	elif object.Name == "bar":
		
		$Bar/PositionX.text = str(object.Position.x)
		$Bar/PositionY.text = str(object.Position.y)
		$Bar/PositionZ.text = str(object.Position.z)
		
		$Bar/RotationX.text = str(rad2deg(object.Rotation.x))
		$Bar/RotationY.text = str(rad2deg(object.Rotation.y))
		$Bar/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Bar/TemplateName.text = str(object.Template)
		
		$Bar/Maxwidth.text = str(object.Maxwidth)
		$Bar/Height.text = str(object.Height)
		$Bar/Thickness.text = str(object.Thickness)
		
		$Bar/Move.text = str(object.Move)
		$Bar/Speed.text = str(object.Speed)
		$Bar/Offset.text = str(object.Offset)
		
		$Bar/Blocker.pressed = object.Blocker
		
		$ObjectName.text = "Bar_" + str(id)
		
	elif object.Name == "sweeper":
		
		$Sweeper/PositionX.text = str(object.Position.x)
		$Sweeper/PositionY.text = str(object.Position.y)
		$Sweeper/PositionZ.text = str(object.Position.z)
		
		$Sweeper/RotationX.text = str(rad2deg(object.Rotation.x))
		$Sweeper/RotationY.text = str(rad2deg(object.Rotation.y))
		$Sweeper/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Sweeper/TemplateName.text = str(object.Template)
		
		$Sweeper/Panewidth.text = str(object.Panewidth)
		$Sweeper/Height.text = str(object.Height)
		$Sweeper/Thickness.text = str(object.Thickness)
		
		$Sweeper/Width.text = str(object.Width)
		$Sweeper/Speed.text = str(object.Speed)
		$Sweeper/Speed.text = str(object.Speed)
		$Sweeper/Offset.text = str(object.Offset)
		
		$Sweeper/Beat.pressed = object.Beat
		$Sweeper/RandomOffset.pressed = object.OffsetRandom
		
		$ObjectName.text = "Bar_" + str(id)
		
	elif object.Name == "foldwindow":
		
		$Foldwindow/PositionX.text = str(object.Position.x)
		$Foldwindow/PositionY.text = str(object.Position.y)
		$Foldwindow/PositionZ.text = str(object.Position.z)
		
		$Foldwindow/RotationX.text = str(rad2deg(object.Rotation.x))
		$Foldwindow/RotationY.text = str(rad2deg(object.Rotation.y))
		$Foldwindow/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Foldwindow/TemplateName.text = str(object.Template)
		
		$Foldwindow/Width.text = str(object.Width)
		$Foldwindow/Height.text = str(object.Height)
		
		$Foldwindow/Distance.text = str(object.Distance)
		$Foldwindow/Angle.text = str(rad2deg(object.Angle))
		
		$ObjectName.text = "Foldwindow_" + str(id)
	
	elif object.Name == "beatwindow":
		
		$Beatwindow/PositionX.text = str(object.Position.x)
		$Beatwindow/PositionY.text = str(object.Position.y)
		$Beatwindow/PositionZ.text = str(object.Position.z)
		
		$Beatwindow/RotationX.text = str(rad2deg(object.Rotation.x))
		$Beatwindow/RotationY.text = str(rad2deg(object.Rotation.y))
		$Beatwindow/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Beatwindow/TemplateName.text = str(object.Template)
		
		$Beatwindow/Width.text = str(object.Width)
		
		$Beatwindow/Beat.text = str(object.Beat)
		$Beatwindow/Offset.text = str(object.Offset)
		
		$ObjectName.text = "Beatwindow_" + str(id)
		
	elif object.Name == "rotor":
		
		$Rotor/PositionX.text = str(object.Position.x)
		$Rotor/PositionY.text = str(object.Position.y)
		$Rotor/PositionZ.text = str(object.Position.z)
		
		$Rotor/RotationX.text = str(rad2deg(object.Rotation.x))
		$Rotor/RotationY.text = str(rad2deg(object.Rotation.y))
		$Rotor/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Rotor/TemplateName.text = str(object.Template)
		
		$Rotor/Width.text = str(object.Width)
		$Rotor/Length.text = str(object.Length)
		$Rotor/Thickness.text = str(object.Thickness)
		
		$Rotor/Beat.text = str(object.Beat)
		$Rotor/Speed.text = str(object.Speed)
		$Rotor/Offset.text = str(object.Offset)
		
		$Rotor/Arms.text = str(object.Arms)
		$Rotor/Radius.text = str(object.Radius)
		
		$ObjectName.text = "Rotor_" + str(id)
		
	elif object.Name == "revolver":
		
		$Revolver/PositionX.text = str(object.Position.x)
		$Revolver/PositionY.text = str(object.Position.y)
		$Revolver/PositionZ.text = str(object.Position.z)
		
		$Revolver/RotationX.text = str(rad2deg(object.Rotation.x))
		$Revolver/RotationY.text = str(rad2deg(object.Rotation.y))
		$Revolver/RotationZ.text = str(rad2deg(object.Rotation.z))
		
		$Revolver/TemplateName.text = str(object.Template)
		
		$Revolver/Width.text = str(object.Width)
		$Revolver/Height.text = str(object.Height)
		$Revolver/Speed.text = str(object.Speed)
		$Revolver/Offset.text = str(object.Offset)
		
		$ObjectName.text = "Revolver_" + str(id)

func _show(object : Dictionary, id : int):
	$InspectorAnimation.stop()
	$InspectorAnimation.play("Show")
	
	_update(object, id)
	
	root._object_release()
	
	selected_id = id
	
	selected = object
	active = true

func _close():
	Sound._play("Close")
	
	$Box._reset()
	$Decal._reset()
	$Powerup._reset()
	$Score._reset()
	$Bar._reset()
	$Sweeper._reset()
	$Foldwindow._reset()
	$Beatwindow._reset()
	$Rotor._reset()
	$Revolver._reset()
	
	$InspectorAnimation.stop()
	$InspectorAnimation.play("Hide")
	active = false

func _popup(window : String, action : String, arg):
	
	if window == "BoxTemplate":
		if action == "Select":
			
			if arg[1] == "BoxInspector":
				
				$Box/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
	if window == "CrystalTemplate":
		if action == "Select":
			
			if arg[1] == "CrystalInspector":
				
				$Score/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
	if window == "GlassTemplate":
		if action == "Select":
			
			if arg[1] == "BarInspector":
				
				$Bar/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "SweeperInspector":
				
				$Sweeper/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "FoldwindowInspector":
				
				$Foldwindow/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "BeatwindowInspector":
				
				$Beatwindow/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "RotorInspector":
				
				$Rotor/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "RevolverInspector":
				
				$Revolver/TemplateName.text = arg[0]
				
				root._set_object(selected_id, "Template", arg[0])
				root._sync_object(selected_id)
				
	if window == "TileLoader":
		if action == "Select":
				
			$Box/Tile.text = str(arg)
			
			root._set_object(selected_id, "Tile", arg)
			root._sync_object(selected_id)
			
	if window == "DecalLoader":
		if action == "Select":
				
			$Decal/DecalID.text = str(arg)
			
			root._set_object(selected_id, "Tile", arg)
			root._sync_object(selected_id)
			
	if window == "Powerup":
		if action == "Select":
				
			$Powerup/Type.text = str(arg)
			
			root._set_object(selected_id, "Type", arg)
			root._sync_object(selected_id)
			
	if window == "ColorPicker":
		if action == "Select":
			
			if arg[1] == "BoxInspector":
				
				$Box/ColorR.text = str(arg[0].r)
				$Box/ColorG.text = str(arg[0].g)
				$Box/ColorB.text = str(arg[0].b)
				
				root._set_object(selected_id, "Color", arg[0])
				root._sync_object(selected_id)
				
			elif arg[1] == "DecalInspector":
				
				$Decal/ColorR.text = str(arg[0].r)
				$Decal/ColorG.text = str(arg[0].g)
				$Decal/ColorB.text = str(arg[0].b)
				
				var col = {
					r = arg[0].r,
					g = arg[0].g,
					b = arg[0].b
				}
				
				root._set_object(selected_id, "Color", col)
				root._sync_object(selected_id)

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	_close()

func _on_Remove_button_down():
	Sound._play("Select")

func _on_Remove_button_up():
	root._remove_object(selected_id)
	_close()
	Sound._play("CloseOld")

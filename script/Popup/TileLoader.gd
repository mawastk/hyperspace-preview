extends Node2D

var touch = false

var selected = -1

func _reset():
	$Cursor/CursorAnimation.stop()
	$Cursor/CursorAnimation.play("Animation")
	
	$Select.disabled = true

func _physics_process(_delta):
	if get_parent().get_parent().get_parent().open == true and get_parent().get_parent().get_parent().open_window == "TileLoader":
		var mouse_pos = get_viewport().get_mouse_position()
		
		if mouse_pos.x > 48 and mouse_pos.x < 720 and mouse_pos.y > 104 and mouse_pos.y < 384 + 56:
			
			if touch == false:
				return
			
			var fixed_pos = mouse_pos - Vector2(48,104)
			
			var coord = Vector2(int(fixed_pos.x / 56), int(fixed_pos.y / 56))
			
			_select(coord)

func _select(coord):
	
	var id = 0
	
	id += coord.y * 12
	id += coord.x
	
	if id < 64:
			
		$Preview/Preview.texture = TemplateManager._get_tile_texture(id)
		$Preview/ID.text = str(id) + " (" + str(int(id) % 8) + "x" + str(int(int(id) / 8)) + ")"
		
		selected = id
		
		$Select.disabled = false
		
		_cursor(
			Vector2(
				coord.x * 56,
				coord.y * 56
			)
		)

func _cursor(pos : Vector2):
	
	if !$Cursor.position == pos:
		
		$Cursor/CursorGlobalAnim.stop()
		$Cursor/CursorGlobalAnim.play("Select")
		
		Sound._play("Laser")
		
		$Cursor.position = pos

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch = true
		elif event.pressed == false:
			touch = false

func _on_Close_button_down():
	Sound._play("Select")

func _on_Close_button_up():
	get_node("../../../")._close()

func _on_Select_button_down():
	Sound._play("Select")

func _on_Select_button_up():
	get_node("../../../")._send(self.name, "Select", selected)

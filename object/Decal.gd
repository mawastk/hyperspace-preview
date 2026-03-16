extends Spatial

var position = Vector3(0,0,0)
var size = Vector3(1,1,0)
var rot = Vector3(0,0,0)

var texture = StreamTexture

var color = Color(1.0, 1.0, 1.0)

var type = "normal"

var id = 0

var capture = false

func _ready():
	$Sprite/Collision.connect("input_event", self, "on_input_event")
	
	if type == "normal":
		
		$Sprite.pixel_size = 0.016
		$Sprite/Collision.scale = Vector3(1.42, 1.42, 1)
		
	elif type == "door":
		
		$Sprite.pixel_size = 0.004
		
	
	$Sprite.texture = texture
	$Sprite.modulate = color
	$Sprite.rotation = rot
	$Sprite.scale = size
	
	self.translation = position

func _tile(id : int):
	var number = id
	var fixed_number = ""
	if number > -1:
	
		if str(number).length() == 1:
			fixed_number = "00" + str(number)
		if str(number).length() == 2:
			fixed_number = "0" + str(number)
		if str(number).length() == 3:
			fixed_number = str(number)
		
		self.type = "normal"
		
		self.texture = load("res://image/decal/decal" + fixed_number + ".png")
	
	else:
		
		fixed_number = str(abs(number))
		
		self.type = "door"
		
		self.texture = load("res://image/door/door" + fixed_number + ".png")
	
	if type == "normal":
		
		$Sprite.pixel_size = 0.016
		$Sprite/Collision.scale = Vector3(1.42, 1.42, 1)
		
	elif type == "door":
		
		$Sprite.pixel_size = 0.004
		$Sprite/Collision.scale = Vector3(1, 1, 1)
		
	
	$Sprite.texture = texture

func _scale(size_arg : Vector3):
	$Sprite.scale = size_arg

func _rotation(rot_arg : Vector3):
	$Sprite.rotation = rot_arg

func _color(color_arg : Color):
	$Sprite.modulate = color_arg

func on_input_event(camera, event, click_position, click_normal, shape_idx):
	
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		if capture == false:
			$Timer.start()
			capture = true
		else:
			get_tree().call_group("Main","_decal_selected", id)

func _on_Timer_timeout():
	capture = false

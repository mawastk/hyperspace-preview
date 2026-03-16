extends Spatial

var template = "basic_glass"

var width = 3
var height = 1

var distance = 8
var angle = -1.57079632679

var id = 0

var camera_distance = 0

var capture = false

var check = false

func _check(active : bool):
	check = active
	$Check.visible = active
	_update()

func _update():
	
	$Mesh.rotation_degrees.x = rad2deg(angle)
	
	$Mesh/Metal.scale = Vector3(
		width / 2.0,
		0.1,
		0.05
	)
	
	$Mesh/Glass.scale = Vector3(
		width / 2.0,
		height - 0.1,
		0.04
	)
	
	$Mesh/Glass.translation.y = height
	
	if check == true:
		
		$Check/CheckMove.scale = $Mesh/Glass.scale
		
		$Check/CheckMove.translation = Vector3(
			0,
			height - 0.1,
			0
		)
	
	var material = SpatialMaterial.new()
	
	var template_value = TemplateManager._get_template("glass", template)
	
	material.albedo_color = Color(
		template_value.color[0],
		template_value.color[1],
		template_value.color[2]
	)
	
	material.albedo_texture = ImageLoader._get_image("glass")
	
	material.uv1_triplanar = true
	material.uv1_scale = $Mesh/Glass.scale
	
	$Mesh/Glass.material_override = material

func _on_Collision_input_event(camera, event, position, normal, shape_idx):
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		if capture == false:
			$Timer.start()
			capture = true
		else:
			get_tree().call_group("Main","_obstacle_selected", id)

func _on_Timer_timeout():
	capture = false

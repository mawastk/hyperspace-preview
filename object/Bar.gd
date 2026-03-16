extends Spatial

var template = "basic_glass"

var height = 0.12
var thickness = 0.12
var maxwidth = 10

var move = 0
var speed = 1
var offset = 0

var blocker = true

var id = 0

var camera_distance = 0

var capture = false

var check = false

func _check(active : bool):
	check = active
	$Mesh/Check.visible = active
	_update(true)

func _final():
	_update(true)

func _update(raycast = false):
	
	var width = maxwidth / 2.0
	
	$Mesh/Glass.scale = Vector3(
		width,
		height,
		thickness
	)
	
	$Mesh/SideBlockLeft.scale = Vector3(
		0.05,
		height + 0.05,
		thickness + 0.05
	)
	
	$Mesh/SideBlockRight.scale = $Mesh/SideBlockLeft.scale
	
	$Mesh/SideBlockRight.translation.x = width - 0.05
	$Mesh/SideBlockLeft.translation.x = float(width + 0.05) * -1
	
	if blocker == true:
		
		$Mesh/Blocker.show()
		
		$Mesh/Blocker.scale = Vector3(
			thickness + 0.2,
			0.5,
			thickness + 0.2
		)
		
	else:
		$Mesh/Blocker.hide()
	
	if raycast == true:
		var right = _raycast(Vector3.ZERO, "x", maxwidth / 2.0)
		var left = _raycast(Vector3.ZERO, "x", maxwidth / 2.0, true)
		
		if right[0] == null:
			right = width
		else:
			right = right[0].x
			
		if left[0] == null:
			left = width * -1
		else:
			left = left[0].x
		
		$Mesh/Glass.scale.x = abs(right - left) / 2.0
		$Mesh.translation.x = lerp(left, right, 0.5)
		
		$Mesh/SideBlockLeft.translation.x = float($Mesh/Glass.scale.x - 0.05) * -1
		$Mesh/SideBlockRight.translation.x = $Mesh/Glass.scale.x - 0.05
	
	if check == true:
		
		var camera_pos = self.translation
		camera_pos.x = 0
		camera_pos.y = 1
		
		$Mesh/Check/Check.scale = $Mesh/Glass.scale
		$Mesh/Check/Check.translation.y = sin(float(_camera_distance(camera_pos) - 0.2 + offset) * speed) * move
		
		$Mesh/Check/CheckMove.scale = $Mesh/Glass.scale
		$Mesh/Check/CheckMove.scale.y = move + 0.05
		
		$Mesh/Check/Check.scale.z -= 0.01
	
	var glass_template = TemplateManager._get_template("glass", template)
	
	var material = SpatialMaterial.new()
	
	material.albedo_texture = ImageLoader._get_image("glass")
	material.albedo_color = Color(
		glass_template.color[0],
		glass_template.color[1],
		glass_template.color[2]
	)
	
	material.uv1_scale = $Mesh/Glass.scale
	material.uv1_triplanar = true
	
	$Mesh/Glass.material_override = material

func _camera_distance(player_pos: Vector3):
	var camera_pos = player_pos
	return camera_pos.distance_to(self.translation)

func _raycast(position: Vector3, axis: String, length : float, negative: bool = false):
	var space_state = get_world().direct_space_state
	
	var local_dir = Vector3.ZERO
	match axis.to_lower():
		"x":
			local_dir = Vector3(1,0,0)
		"y":
			local_dir = Vector3(0,1,0)
		"z":
			local_dir = Vector3(0,0,1)
	
	if negative:
		local_dir = -local_dir
	
	var world_origin = to_global(position)
	var world_dir = global_transform.basis.xform(local_dir).normalized()
	var world_to = world_origin + world_dir * length
	
	var result = space_state.intersect_ray(world_origin, world_to, [], 1)
	
	if result.empty():
		return [null]
	
	return [to_local(result.position), result.collider.name]

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

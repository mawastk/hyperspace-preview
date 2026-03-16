extends Spatial

var position = Vector3(0,0,0)
var size = Vector3(1,1,1)

var texture = {
	x = StreamTexture,
	y = StreamTexture,
	z = StreamTexture
}

var color = {
	x = Color(1.0, 1.0, 1.0),
	y = Color(1.0, 1.0, 1.0),
	z = Color(1.0, 1.0, 1.0)
}

var tile_size = {
	x = 1,
	y = 1,
	z = 1
}

var id = 0

var capture = false

func _set_texture(texture_x, texture_y = null, texture_z = null):
	
	if texture_y == null and texture_z == null:
		
		texture.x = TemplateManager._get_tile_texture(texture_x)
		texture.y = texture.x
		texture.z = texture.x
	
	else:
		
		texture.x = TemplateManager._get_tile_texture(texture_x)
		texture.y = TemplateManager._get_tile_texture(texture_y)
		texture.z = TemplateManager._get_tile_texture(texture_z)

func _set_color(color_x, color_y = null, color_z = null):
	
	if color_y == null and color_z == null:
		
		color.x = color_x
		color.y = color_x
		color.z = color_x
	
	else:
		
		color.x = color_x
		color.y = color_y
		color.z = color_z
		
func _set_tilesize(tilesize_x, tilesize_y = null, tilesize_z = null):
	
	if tilesize_y == null and tilesize_z == null:
		
		tile_size.x = tilesize_x
		tile_size.y = tilesize_x
		tile_size.z = tilesize_x
	
	else:
		
		tile_size.x = tilesize_x
		tile_size.y = tilesize_y
		tile_size.z = tilesize_z

func _ready():
	$Collision.connect("input_event", self, "on_input_event")
	
	self.translation = position
	self.scale = size
	
	_update_uv()

func _update_uv():
	
	position = self.translation
	size = self.scale
	
	var material = {
		x = SpatialMaterial.new(),
		y = SpatialMaterial.new(),
		z = SpatialMaterial.new()
	}
	
	material.x.albedo_texture = texture.x
	material.x.albedo_color = color.x
	
	material.y.albedo_texture = texture.y
	material.y.albedo_color = color.y
	
	material.z.albedo_texture = texture.z
	material.z.albedo_color = color.z
	
	material.x.uv1_scale = Vector3(size.z / tile_size.z, size.x / tile_size.x, size.y / tile_size.y)
	material.y.uv1_scale = Vector3(size.x / tile_size.x, size.y / tile_size.y, size.z / tile_size.z)
	material.z.uv1_scale = Vector3(size.x / tile_size.x, size.z / tile_size.z, size.y / tile_size.y)
	
	var uv_offset_x = Vector3(
		float(size.z / tile_size.z) - floor(size.z),
		float(size.x / tile_size.x) - floor(size.x),
		float(size.y / tile_size.y) - floor(size.y)
	)
	var uv_offset_y = Vector3(
		float(size.x / tile_size.x) - floor(size.x),
		float(size.y / tile_size.y) - floor(size.y),
		float(size.z / tile_size.z) - floor(size.z)
	)
	var uv_offset_z = Vector3(
		float(size.x / tile_size.x) - floor(size.x),
		float(size.z / tile_size.z) - floor(size.z),
		float(size.y / tile_size.y) - floor(size.y)
	)
	
	material.x.uv1_offset = uv_offset_x
	material.y.uv1_offset = uv_offset_y
	material.z.uv1_offset = uv_offset_z
	
	material.x.uv1_triplanar = true
	material.y.uv1_triplanar = true
	material.z.uv1_triplanar = true
	
	$Mesh/x_pos.material_override = material.x
	$Mesh/x_neg.material_override = material.x
	$Mesh/y_pos.material_override = material.y
	$Mesh/y_neg.material_override = material.y
	$Mesh/z_pos.material_override = material.z
	$Mesh/z_neg.material_override = material.z

func _clickable(active : bool):
	$Collision.input_ray_pickable = active

func on_input_event(camera, event, click_position, click_normal, shape_idx):
	
	var mouse_click = event as InputEventMouseButton
	if mouse_click and mouse_click.button_index == 1 and mouse_click.pressed:
		if capture == false:
			$Timer.start()
			capture = true
		else:
			get_tree().call_group("Main","_box_selected", id)

func _on_Timer_timeout():
	capture = false

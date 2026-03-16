extends Spatial

var sensitivity := 0.18
var min_pitch := -80
var max_pitch := 80
var smooth_speed := 20

var pitch := 0.0
var target_pitch := 0.0

var yaw := 0.0
var target_yaw := 0.0

var dragging := false

var move_speed := 5.0

onready var camera = self

var up = false
var down = false
var left = false
var right = false
var space = false
var fall = false

var block = false

var reseting = false

var gizmo_focus = false
var gizmo_axis = "x"
var gizmo_offset = Vector3.ZERO
var gizmo_capture = false
var gizmo_mouse = Vector2.ZERO

func _ready():
	pitch = camera.rotation_degrees.x
	target_pitch = pitch
	
	yaw = rotation_degrees.y
	target_yaw = yaw

func _input(event):
	
	if event is InputEventScreenTouch:
		dragging = event.pressed
	
	if event is InputEventScreenDrag and dragging and gizmo_focus == false and GlobalPopup.open == false:
		
		if block == false:
		
			target_yaw += -event.relative.x * sensitivity
			target_pitch += -event.relative.y * sensitivity
			target_pitch = clamp(target_pitch, min_pitch, max_pitch)
	
	if event is InputEventMouseButton:
		
		if event.pressed == true and event.button_index == 1:
			
			if gizmo_focus == false:
			
				var mouse_pos = get_viewport().get_mouse_position()
				var camera = self
				var from = camera.project_ray_origin(mouse_pos)
				var dir = camera.project_ray_normal(mouse_pos)
				var to = from + dir * 1000
				
				var space_state = get_world().direct_space_state
				var result = space_state.intersect_ray(from, to, [], 2)
				
				if result:
					gizmo_axis = result.collider.name
					gizmo_mouse = get_viewport().get_mouse_position()
					gizmo_focus = true
		
		elif event.pressed == false:
			
			if gizmo_focus == true:
				get_parent()._object_release()
				gizmo_focus = false
				gizmo_capture = false

func _reset():
	reseting = true
	
	$CameraTween.interpolate_property(
		self,
		"translation",
		self.translation,
		Vector3(0,1,0),
		0.8,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	$CameraTween.start()
	$CameraTween.interpolate_property(
		self,
		"rotation_degrees",
		self.rotation_degrees,
		Vector3(0,0,0),
		0.8,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	$CameraTween.start()

func _process(_delta):
	if gizmo_focus == true:
		
		var camera = self
		
		var gizmo_node = get_node("%Gizmo")
		
		var mouse_pos = get_viewport().get_mouse_position()
		var delta_mouse = mouse_pos - gizmo_mouse
		gizmo_mouse = mouse_pos
		
		var axis_vec = Vector3.RIGHT
		if gizmo_axis == "y":
			axis_vec = Vector3.UP
		elif gizmo_axis == "z":
			axis_vec = Vector3.FORWARD
		
		var origin_2d = camera.unproject_position(gizmo_node.global_transform.origin)
		
		var axis_end = camera.unproject_position(gizmo_node.global_transform.origin + axis_vec)
		var axis_2d = (axis_end - origin_2d).normalized()
		
		var move_amount_2d = delta_mouse.dot(axis_2d)
		
		var cam_pos = global_transform.origin
		var gizmo_pos = gizmo_node.global_transform.origin
		var distance = cam_pos.distance_to(gizmo_pos)
		var fov_scale = tan(self.fov * 0.5 * 0.0174533) * distance * 2.0 / get_viewport().size.y
		var move_amount_world = move_amount_2d * fov_scale
		
		if get_node("../").scaling == false:

			if gizmo_axis == "z":
				var value = gizmo_node.global_transform.origin.z - move_amount_world
				gizmo_node._move("z", value)
			else:
				gizmo_node._move(gizmo_axis, gizmo_node.global_transform.origin.dot(axis_vec) + move_amount_world)
		else:
			gizmo_node._scale(gizmo_axis, move_amount_world)
			
func _physics_process(delta):
	
	if block == false and reseting == false:
		sensitivity = get_parent().sensitivity
		smooth_speed = get_parent().smooth

		yaw = lerp(yaw, target_yaw, smooth_speed * delta)
		pitch = lerp(pitch, target_pitch, smooth_speed * delta)
		
		rotation_degrees.y = yaw
		camera.rotation_degrees.x = pitch

		var input_dir = Vector3.ZERO

		if get_node("%Inspector").active == false:
			if up:
				input_dir.z -= get_parent().move_speed
			if down:
				input_dir.z += get_parent().move_speed
			if left:
				input_dir.x -= get_parent().move_speed
			if right:
				input_dir.x += get_parent().move_speed
			if space:
				input_dir.y += get_parent().verticle_speed
			if fall:
				input_dir.y -= get_parent().verticle_speed

		if input_dir == Vector3.ZERO:
			return

		input_dir = input_dir.normalized()

		var yaw = self.rotation.y

		var yaw_basis = Basis(Vector3.UP, yaw)

		var direction = yaw_basis.xform(input_dir)

		self.translation += direction * move_speed * delta

func _on_CameraTween_tween_all_completed():
	pitch = 0.0
	target_pitch = 0.0
	yaw = 0.0
	target_yaw = 0.0
	reseting = false

extends Spatial

var move = preload("res://model/gizmo.obj")
var scaling = preload("res://model/gizmo_scaling.obj")

var mode = "move"

func _process(_delta):
	var distance = Vector3(get_node("%Camera").translation).distance_to(self.translation)
	
	self.scale.x = 0.2 * distance
	self.scale.y = 0.2 * distance
	self.scale.z = 0.2 * distance

func _move(axis : String, value : float):
	
	self.translation[axis] = value
		
	get_parent().get_parent()._object_move(self.translation)
	
func _scale(axis : String, value : float):
		
	get_parent().get_parent()._object_size(axis, value)

func _mode(mode_arg : String):
	
	if mode_arg == "move":
		$gizmo_x.mesh = move
		$gizmo_y.mesh = move
		$gizmo_z.mesh = move
		
	elif mode_arg == "scaling":
		$gizmo_x.mesh = scaling
		$gizmo_y.mesh = scaling
		$gizmo_z.mesh = scaling
	
	mode = mode_arg

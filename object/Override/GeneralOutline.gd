extends MeshInstance

func _visible(arg : bool):
	self.visible = arg

func _process(_delta):
	var distance = Vector3(get_node("../../../../Camera").translation).distance_to(self.translation)
	
	self.scale.x = 0.001 * distance
	self.scale.z = 0.001 * distance

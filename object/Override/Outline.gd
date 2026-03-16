extends MeshInstance

func _process(_delta):
	var distance = Vector3(get_node("../../../../Camera").translation).distance_to(self.translation)
	
	self.scale.x = 0.004 * distance
	self.scale.z = 0.004 * distance

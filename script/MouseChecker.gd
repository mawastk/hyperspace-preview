extends Node

func _check(mouse_pos : Vector2, start : Vector2, end : Vector2):
	
	var detect = false
	
	if mouse_pos.x > start.x and mouse_pos.x < end.x:
		if mouse_pos.y > start.y and mouse_pos.y < end.y:
			detect = true
	
	return detect

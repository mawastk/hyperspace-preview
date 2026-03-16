extends Node

var image = {
	glass = preload("res://image/gfx/glassnormal3.png")
}

func _get_image(image_arg : String):
	return image[image_arg]

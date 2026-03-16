extends CanvasLayer

onready var camera = get_parent().get_node("Camera")

var space = false
var fall = false

func _physics_process(delta):
	
	if space == true:
		camera.translation.z -= float(get_parent().move_speed * 2.3) * delta
	
	if fall == true:
		camera.translation.z += float(get_parent().move_speed * 2.3) * delta

func _ready():
	
	$Space.connect("pressed", self, "_space_pressed")
	$Fall.connect("pressed", self, "_fall_pressed")
	
	$Space.connect("released", self, "_space_released")
	$Fall.connect("released", self, "_fall_released")
	
	$Close.connect("button_down", self, "_close_down")
	$Close.connect("button_up", self, "_close_up")

func _space_pressed():
	space = true
	
func _space_released():
	space = false
	
func _fall_pressed():
	fall = true
	
func _fall_released():
	fall = false

func _close_down():
	Sound._play("Select")

func _close_up():
	get_parent()._preview(false)

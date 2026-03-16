extends Spatial

onready var root = get_node("../../")
var snap = false

func _physics_process(_delta):
	
	snap = root.snap
	
	if root.block_gizmo:
		var camera = get_node("%Camera")
		var spawn_position = camera.global_transform.origin + -camera.global_transform.basis.z * 4
	
		if snap == true:
			spawn_position = Vector3(
				int(spawn_position.x),
				int(spawn_position.y),
				int(spawn_position.z)
			)
			
			if !$Guide.translation == spawn_position and root.block_gizmo:
				Sound._play("Dot")
		
		$Guide.translation = spawn_position

func _ready():
	
	$Guide/Guide/Guide.show()
	
	#if OS.get_name() == "Android":
	#	$Guide/Guide/GuideAlt.show()
	#else:
	#	$Guide/Guide/Guide.show()

func _mode(mode : String):
	
	$Guide/Guide.hide()
	$Guide/Cross.hide()
	
	if mode == "normal":
		$Guide/Guide.show()
	elif mode == "cross":
		$Guide/Cross.show()

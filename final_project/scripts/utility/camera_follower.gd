extends Camera3D

@export var camera_3d : Camera3D

func _process(delta: float) -> void:
	global_position = camera_3d.global_position
	global_rotation = camera_3d.global_rotation

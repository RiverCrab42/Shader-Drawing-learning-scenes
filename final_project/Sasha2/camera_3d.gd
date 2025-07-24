extends Camera3D

@onready var wall: MeshInstance3D = $"../wall"

func _process(delta: float) -> void:
	wall.set_instance_shader_parameter("reflection", get_camera_projection())

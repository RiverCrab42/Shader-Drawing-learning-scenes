@tool
extends DirectionalLight3D

@export var shader_objects : Array[Node3D]

func _process(delta: float) -> void:
	for obj in shader_objects:
		obj.get_surface_override_material(0).set_shader_parameter("light_dir_w", 
		global_basis * Vector3(0.0, 0.0, -1.0))

@tool
extends OmniLight3D

@export var shader_objects : Array[Node3D]

func _process(delta: float) -> void:
	for obj in shader_objects:
		obj.get_surface_override_material(0).set_shader_parameter("light_pos_w", 
		global_position)

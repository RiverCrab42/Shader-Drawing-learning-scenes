extends Camera3D

const BLINN_PHONG_LIGHT_MODEL_MAT = preload("res://materials/Blinn_Phong_light_model_mat.tres")

var angle : float
var dist_from_center : float
var y_start : float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BLINN_PHONG_LIGHT_MODEL_MAT.set_shader_parameter("camera_pos", global_position);
	angle = 0.0
	y_start = global_position.y
	dist_from_center = sqrt(global_position.x * global_position.x + 
		global_position.z * global_position.z)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	angle += delta
	global_position = Vector3(sin(angle) * dist_from_center,
					   y_start,
					   cos(angle) * dist_from_center)
	look_at(Vector3(0,0,0))
	BLINN_PHONG_LIGHT_MODEL_MAT.set_shader_parameter("camera_pos", global_position);

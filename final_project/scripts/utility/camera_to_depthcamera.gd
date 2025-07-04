extends Camera3D

@onready var depth_camera_3d: Node3D = $"../.."

#func _ready() -> void:
	#print(get_camera_transform())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position = depth_camera_3d.global_position
	global_rotation = depth_camera_3d.global_rotation

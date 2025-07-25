extends Camera3D

var character : Node3D
var active : bool = true

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	character = get_parent_node_3d()

func _process(_delta):
	rotation.x = clamp(rotation.x, -1.2, 1.2)

func _input(event):
	if !active:
		return;
	if event is InputEventMouseMotion:
		character.rotate(Vector3.UP,
			event.relative.x * -0.005
		)
		rotate_object_local(Vector3.RIGHT,
			event.relative.y * -0.005
		)

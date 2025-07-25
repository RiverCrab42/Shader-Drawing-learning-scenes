extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var prev_mouse_pos : Vector2
var underwater : bool

@onready var camera_3d: Camera3D = $Camera3D
@onready var ray_cast_3d: RayCast3D = $Camera3D/RayCast3D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		if underwater:
			velocity += get_gravity() * delta * 0.5
		else:
			velocity += get_gravity() * delta
	
	# Handle jump.
	if underwater:
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#(transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	check_raycast()
	
	move_and_slide()

var selected_this_frame : bool = false

func recursive_find_selected(obj : Node) -> void:
	if obj is Selectable:
		SelectableManager.select(obj as Selectable)
		selected_this_frame = true
	var parent = obj.get_parent()
	if parent:
		recursive_find_selected(parent)

func check_raycast() -> void:
	var obj = ray_cast_3d.get_collider()
	selected_this_frame = false
	if obj:
		recursive_find_selected(obj)
	if !selected_this_frame:
		SelectableManager.unselect_all()

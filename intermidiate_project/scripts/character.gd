extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@export_range(50.0, 500.0, 1.0) var gravity : float
@export_range(10.0, 500.0, 1.0) var speed : float
@export_range(5.0, 500.0, 1.0) var speed_air : float
@export_range(10.0, 800.0, 1.0) var jump_velocity : float
@export_range(0.0, 2.0, 0.1) var coyote_time : float;

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0.0, gravity * delta)

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

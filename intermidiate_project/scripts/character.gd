extends CharacterBody2D


@export var speed : float = 300.0
@export var gravity : float = 1500.0
@export var acceleration_ground : float = 20000.0
@export var acceleration_air = 3600.0
@export var jump_velocity = -600.0
@export var coyote_time = 0.1
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var lastOnFloor = 0.0

var slide = false

func set_slide(value : bool) -> void:
	slide = value
	if slide:
		acceleration_ground = 700.0
	else:
		acceleration_ground = 1000.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0.0, gravity * delta)
		lastOnFloor += delta
	else: 
		lastOnFloor = 0.0
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || lastOnFloor < coyote_time):
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if not(is_on_floor()):
		velocity.x = move_toward(velocity.x, direction * speed, acceleration_air * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration_ground * delta)
		else:
			if slide:
				move_toward(velocity.x, direction * speed, acceleration_ground * delta)
			else:
				velocity.x = move_toward(velocity.x, 0, speed * 1.5)
	
	animate(direction)
	move_and_slide()

func animate(direction : float) -> void:
	if not(is_on_floor()):
		animated_sprite_2d.play("jump") 
	else:
		if (direction == 0):
			animated_sprite_2d.play("idle")
		else:
			animated_sprite_2d.play("run")
	if (direction == -1):
		animated_sprite_2d.flip_h = true
	if (direction == 1):
		animated_sprite_2d.flip_h = false

class_name Player
extends CharacterBody2D

const arrow = preload("res://scenes/collectables/arrow.tscn")

@export var speed : float = 200.0
@export var gravity : float = 2000.0
@export var acceleration_ground : float = 50000.0
@export var acceleration_air = 3600.0
@export var jump_velocity = -800.0
@export var max_fall_speed = 800.0
@export var coyote_time = 0.1
@export var time_between_shots = 0.1

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var lastOnFloor = 0.0
var lastShot = 0.0
var level_viewport : Vector2i

const arrow_offset : float = 5.0

func _ready() -> void:
	add_to_group("player")
	level_viewport = get_viewport_rect().size

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += Vector2(0.0, gravity * delta)
		if velocity.y > max_fall_speed:
			velocity.y = max_fall_speed
		lastOnFloor += delta
	else: 
		lastOnFloor = 0.0
	# Handle jump.
	if Input.is_action_just_pressed("jump") and (is_on_floor() || lastOnFloor < coyote_time):
		velocity.y = jump_velocity
		NamarichSignals.do_ripples.emit(global_position)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("move_left", "move_right")
	if not(is_on_floor()):
		velocity.x = move_toward(velocity.x, direction * speed, acceleration_air * delta)
	else:
		if direction:
			velocity.x = move_toward(velocity.x, direction * speed, acceleration_ground * delta)
		else:
			velocity.x = move_toward(velocity.x, 0, speed * 1.5)
	
	#if the character crosses the screen - teleport him to the other side
	if global_position.x > level_viewport.x:
		global_position.x = 0.0
	elif global_position.x < 0.0:
		global_position.x = level_viewport.x
	
	if global_position.y > level_viewport.y:
		global_position.y = 0.0
	elif global_position.y < 0.0:
		global_position.y = level_viewport.y
		
	check_shoot(delta)
	animate(direction)
	move_and_slide()

func check_shoot(delta : float) -> void:
	var dir_mod : Vector2
	var gravity
	var max_fall_speed
	
	if Input.is_action_just_released("shoot") &&\
		lastShot > time_between_shots &&\
		GameManager.arrows > 0:
		var arrow_obj = GameManager.my_instantiate(arrow)
		get_tree().root.add_child(arrow_obj)
		var target = get_global_mouse_position()
		var direction = (target - global_position).normalized()
		gravity = arrow_obj.gravity
		var arr_mfs = arrow_obj.max_fall_speed
		dir_mod = direction# + velocity.dot(direction) * direction / arr_mfs
		
		#transfer some of player's momentum to the arrow
		arrow_obj.direction = dir_mod
		arrow_obj.global_position = global_position + direction * arrow_offset
		GlobalSignals.shoot_arrow.emit()
		lastShot = 0.0
	else:
		lastShot += delta
		
	if Input.is_action_pressed("shoot"):
		var target = get_global_mouse_position()
		var direction = (target - global_position).normalized()
		dir_mod = direction# + velocity.dot(direction) * direction / 8.0
		NamarichSignals.redraw_trajectory.emit(dir_mod,self.global_position,0.5,8.0)
		

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

var can_get_hit : bool = true

func get_hit() -> void:
	if can_get_hit:
		animation_player.play("hit")
		GlobalSignals.took_damage.emit()
		animation_player.animation_finished.connect(reset_hit)
		can_get_hit = false
	
func reset_hit(anim_name : String) -> void:
	can_get_hit = true

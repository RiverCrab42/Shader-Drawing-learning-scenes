class_name ArrowNew
extends Node2D

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D

@export var gravity : float = 0.5
@export var max_fall_speed : float = 10.0
@export var speed : float = 300.0

var enemies_damaged : Array

@onready var ray_cast_2d: RayCast2D = $RayCast2D

var direction : Vector2 = Vector2(1.0, 0.0)
var stuck : bool
var level_viewport : Vector2i

@onready var fireLight : PointLight2D = $PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_viewport = get_viewport_rect().size
	sprite_2d.flip_h = true
	stuck = false
	fireLight.visible = false
	set_meta("fire",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Down"):
		fire()
	
	if !stuck:
		direction.y += gravity * delta
		if direction.y > max_fall_speed:
			direction.y = max_fall_speed
		var needed_rot = get_angle_to(global_position + direction)
		rotate(needed_rot)
		if ray_cast_2d.is_colliding():
			var dist = global_position.distance_to(ray_cast_2d.get_collision_point())
			if (direction * speed * delta).length() > dist:
				global_position += direction.normalized() * dist
			else:
				global_position += direction * speed * delta
		else:
			global_position += direction * speed * delta
		
		if global_position.x > level_viewport.x:
			global_position.x = 0.0
		elif global_position.x < 0.0:
			global_position.x = level_viewport.x
		
		if global_position.y > level_viewport.y:
			global_position.y = 0.0
		elif global_position.y < 0.0:
			global_position.y = level_viewport.y


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !(body is CharacterBody2D):
		stuck = true
	if (body is CharacterBody2D) and stuck:
		GlobalSignals.collected_arrow.emit()
		queue_free()

func fire():
	print("--- FIRE ARROW ---")
	fireLight.visible = true
	set_meta("fire",true)
	#$Sprite2D.set_instance_shader_parameter("fire",1.0)

extends Node2D

const SPEED = 40.0

var direction = 1
@onready var right_ray: RayCast2D = $RightRay
@onready var left_ray: RayCast2D = $LeftRay
@onready var down_right_ray: RayCast2D = $DownRightRay
@onready var down_left_ray: RayCast2D = $DownLeftRay

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += direction * SPEED * delta
	if (right_ray.is_colliding() or not(down_right_ray.is_colliding())):
		direction = -1
		animated_sprite_2d.flip_h = true
	if (left_ray.is_colliding() or not(down_left_ray.is_colliding())):
		direction = 1
		animated_sprite_2d.flip_h = false
